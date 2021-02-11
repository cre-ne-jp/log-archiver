# frozen_string_literal: true

# メッセージ期間検索のモデル
class MessagePeriod < ApplicationModel
  include ActiveModel::Validations::Callbacks

  # 検索件数の最大数
  RESULT_LIMIT = 5000

  # メッセージ期間検索の結果を表す構造体
  # @!attribute channels
  #   @return [Array<Channel>] 検索対象チャンネルの配列
  # @!attribute messages
  #   @return [Array<Message, ConversationMessage>] 該当メッセージの配列
  # @!attribute conversation_messages_count
  #   @return [Integer] 該当メッセージのうち発言の件数
  # @!attribute privmsg_keyword_relationships
  #   @return [Array<PrivmsgKeywordRelationship>] PRIVMSG-キーワード関連の配列
  # @!attribute keywords_privmsgs_for_header
  #   @return [Array<(Keyword, Privmsg)>] キーワード -> PRIVMSGの対応の配列
  MessagePeriodResult = Struct.new(
    :channels,
    :messages,
    :conversation_messages_count,
    :privmsg_keyword_relationships,
    :keywords_privmsgs_for_header
  )

  class MessagePeriodResult
    # @return [Boolean] メッセージの件数が上限値に達したか
    def num_of_messages_limited?
      messages.length >= RESULT_LIMIT
    end
  end

  # チャンネル識別子
  #
  # パラメータ名の都合で名前がchannelsでも識別子を表すことに注意。
  # @return [Array<String>]
  attr_accessor :channels
  # 開始日
  # @return [Time, nil]
  #
  # 名称はGoogle検索に準拠している。
  #
  # セッターでは、Time 型に変換できないときは nil になる。
  attr_reader :since
  # 終了日
  # @return [Time, nil]
  #
  # 名称はGoogle検索に準拠している。
  #
  # セッターでは、Time 型に変換できないときは nil になる。
  attr_reader :until

  validates :channels, presence: true
  validates :since_or_until, presence: true

  validate :until_must_not_be_less_than_since_if_both_exist

  def initialize(*)
    @channels = []
    super
  end

  # 開始日時を設定する
  #
  # Time 型に変換できないときは nil になる。
  # @param [#to_time] value 開始日時
  def since=(value)
    begin
      @since = value.to_time
    rescue
      @since = nil
    end
  end

  # 終了日時を設定する
  #
  # Time 型に変換できないときは nil になる。
  # @param [#to_time] value 終了日時
  def until=(value)
    begin
      @until = value.to_time
    rescue
      @until = nil
    end
  end

  # 属性のハッシュを返す
  # @return [Hash]
  def attributes
    {
      'channels' => @channels,
      'since' => @since,
      'until' => @until
    }
  end

  # 指定したハッシュを使って属性を設定する
  # @param [Hash] hash 属性の設定に使うハッシュ
  # @return [void]
  def attributes=(hash)
    self.channels = hash['channels']
    self.since = hash['since']
    self.until = hash['until']
  end

  # 結果ページ向けの属性のハッシュを返す
  # @return [Hash]
  def attributes_for_result_page
    {
      'channels' => @channels.join(' '),
      'since' => @since&.strftime('%F %T'),
      'until' => @until&.strftime('%F %T')
    }
  end

  # 結果ページのパラメータのハッシュを使って属性を設定する
  # @param [Hash] hash 属性の設定に使うハッシュ
  # @return [Hash] 指定したハッシュ
  def set_attributes_with_result_page_params(params)
    self.channels = params['channels']&.split(' ') || []
    self.since = params['since']
    self.until = params['until']
  end

  # 検索結果を返す
  # @return [MessagePeriodResult] 検索結果
  # @return [nil] 属性が正しくなかった場合
  def result
    return nil unless valid?

    channels = @channels.empty? ?
      [] : Channel.where(identifier: @channels.split).to_a

    messages = Message.
      filter_by_channels(channels).
      filter_by_since(@since).
      filter_by_until(@until).
      order(timestamp: :asc, id: :asc).
      limit(RESULT_LIMIT + 1).
      includes(:channel, :irc_user).
      to_a

    @until = messages.last.timestamp if messages.count > RESULT_LIMIT

    conversation_messages = ConversationMessage.
      filter_by_channels(channels).
      filter_by_since(@since).
      filter_by_until(@until).
      order(timestamp: :asc, id: :asc).
      limit(RESULT_LIMIT).
      includes(:channel, :irc_user)

    i = 0
    result_messages =
      (messages.to_a + conversation_messages.to_a).
      sort_by { |m| [m.timestamp, i += 1] }.
      first(RESULT_LIMIT)

    # ソートしたメッセージから、ConversationMessage だけ抽出する
    result_conversation_messages = result_messages.grep(ConversationMessage)

    privmsg_keyword_relationships =
      privmsg_keyword_relationships_from(result_conversation_messages)
    keywords_privmsgs_for_header =
      privmsg_keyword_relationships.
      sort_by { |r| r.privmsg.timestamp }.
      group_by(&:keyword).
      map { |keyword, relations| [keyword, relations.map(&:privmsg)] }

    MessagePeriodResult.new(
      channels,
      result_messages,
      result_conversation_messages.count,
      privmsg_keyword_relationships,
      keywords_privmsgs_for_header
    )
  end

  private

  # 開始日時または終了日時が存在するか
  # @return [Boolean]
  def since_or_until
    @since.presence || @until.presence
  end

  # 開始日時と終了日時が共に指定されているときは、
  # 開始日時が終了日時より後になっていないことを確認する
  def until_must_not_be_less_than_since_if_both_exist
    if @since && @until
      if @since > @until
        errors.add(
          :until,
          I18n.t('errors.messages.greater_than_or_equal_to',
                 count: @since)
        )
      end
    end
  end
end
