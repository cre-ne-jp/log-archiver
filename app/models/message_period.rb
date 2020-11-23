# メッセージのキーワード検索のモデル
class MessagePeriod
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  # メッセージ検索の結果
  MessagePeriodResult = Struct.new(:channels, :conversation_messages, :messages)

  # チャンネル識別子
  #
  # パラメータ名の都合で名前がchannelsでも識別子を表すことに注意。
  # @return [Array<String>]
  attr_accessor :channels
  # 開始日時
  # @return [Time, nil]
  #
  # 名称はGoogle検索に準拠している。
  #
  # セッターでは、Time 型に変換できないときは nil になる。
  attr_reader :since
  # 終了日時
  # @return [Time, nil]
  #
  # 名称はGoogle検索に準拠している。
  #
  # セッターでは、Time 型に変換できないときは nil になる。
  attr_reader :until

  # ページ番号
  # @return [Integer]
  #
  # セッターでは、1以上でないときは1になる。
  attr_reader :page

  validates(
    :page,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1
    }
  )

  validate :until_must_not_be_less_than_since_if_both_exist

  before_validation :correct_page

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

  # ページ番号を設定する
  #
  # 1以上でないときは1になる
  # @param [#to_i] value ページ番号
  def page=(value)
    begin
      value_i = value.to_i
      @page = (value_i >= 1) ? value_i : 1
    rescue
      @page = 1
    end
  end

  # 属性のハッシュを返す
  # @return [Hash]
  def attributes
    {
      'channels' => @channels,
      'since' => @since,
      'until' => @until,
      'page' => @page
    }
  end

  # 指定したハッシュを使って属性を設定する
  # @param [Hash] hash 属性の設定に使うハッシュ
  # @return [void]
  def attributes=(hash)
    self.channels = hash['channels']
    self.since = hash['since']
    self.until = hash['until']
    self.page = hash['page']
  end

  # 結果ページ向けの属性のハッシュを返す
  # @return [Hash]
  def attributes_for_result_page
    {
      'channels' => @channels.join(' '),
      'since' => @since&.strftime('%F %T'),
      'until' => @until&.strftime('%F %T'),
      'page' => @page
    }
  end

  # 結果ページのパラメータのハッシュを使って属性を設定する
  # @param [Hash] hash 属性の設定に使うハッシュ
  # @return [Hash] 指定したハッシュ
  def set_attributes_with_result_page_params(params)
    self.channels = params['channels']&.split(' ') || []
    self.since = params['since']
    self.until = params['until']
    self.page = params['page']
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
      page(@page).
      includes(:channel)

    next_page_first_conversation_message =
      if conversation_messages.total_pages > 1
        ConversationMessage.
          filter_by_channels(channels).
          filter_by_since(@since).
          filter_by_until(@until).
          select(:timestamp).
          page(@page + 1).
          first
      else
        conversation_messages.last
      end

    since_val, until_val =
      if conversation_messages.empty?
        [@since, @until]
      elsif  conversation_messages.first_page?
        [@since, nil]
      elsif conversation_messages.last_page?
        [nil, @until]
      end
    since_val ||= conversation_messages.first.timestamp
    until_val ||= next_page_first_conversation_message.timestamp

    messages =
      Message.
        filter_by_channels(channels).
        filter_by_since(since_val).
        filter_by_until(until_val).
        order(id: :asc, timestamp: :asc).
        includes(:channel)

    MessagePeriodResult.new(channels, conversation_messages, messages)
  end

  private

  # ページ番号を正しくする
  def correct_page
    @page = 1 if !@page || @page < 1
  end

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
end
