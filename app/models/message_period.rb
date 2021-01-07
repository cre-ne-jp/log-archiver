# メッセージのキーワード検索のモデル
class MessagePeriod < ApplicationModel
  include ActiveModel::Validations::Callbacks

  # メッセージ検索の結果
  MessagePeriodResult = Struct.new(
      :channels,
      :messages,
      :conversation_messages_count,
      :privmsg_keyword_relationships,
      :keywords_privmsgs_for_header
    )

  # チャンネル識別子
  #
  # パラメータ名の都合で名前がchannelsでも識別子を表すことに注意。
  # @return [String]
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

  validate :until_must_not_be_less_than_since_if_both_exist
  validate :until_set_now_datetime_if_not_exist

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

  # 終了日を設定する
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

    conversation_messages = ConversationMessage.
      filter_by_channels(channels).
      filter_by_since(@since).
      filter_by_until(@until).
      order(id: :asc, timestamp: :asc).
      limit(5000).
      includes(:channel, :irc_user)

    if conversation_messages.count >= 5000
      # ToDo: ビューに、取得制限に引っかかったアラートを出す
      @until = conversation_messages.last.timestamp
    end

    messages =
      Message.
        filter_by_channels(channels).
        filter_by_since(@since).
        filter_by_until(@until).
        order(id: :asc, timestamp: :asc).
        includes(:channel, :irc_user)

    privmsg_keyword_relationships =
      privmsg_keyword_relationships_from(conversation_messages)
    keywords_privmsgs_for_header =
      privmsg_keyword_relationships.
      sort_by { |r| r.privmsg.timestamp }.
      group_by(&:keyword).
      map { |keyword, relations| [keyword, relations.map(&:privmsg)] }

    i = 0
    result_messages =
      (messages.to_a + conversation_messages.to_a).
      sort_by { |m| [m.timestamp, i += 1] }

    MessagePeriodResult.new(
      channels,
      result_messages,
      conversation_messages.count,
      privmsg_keyword_relationships,
      keywords_privmsgs_for_header
    )
  end

  private

  # 開始日と終了日が共に指定されているときは、
  # 開始日が終了日より後になっていないことを確認する
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

  # 終了日が設定されていないときは、現在日時を設定する
  def until_set_now_datetime_if_not_exist
    self.until = Time.now unless @until
  end
end
