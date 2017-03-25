# メッセージのキーワード検索のモデル
class MessageSearch
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  # メッセージ検索の結果
  MessageSearchResult = Struct.new(:channel, :messages, :message_groups)

  # 検索文字列
  # @return [String]
  attr_accessor :query
  # チャンネル識別子
  #
  # パラメータ名の都合で名前がchannelでも識別子を表すことに注意。
  # @return [String]
  attr_accessor :channel
  # 開始日
  #
  # 名称はGoogle検索に準拠している。
  # @return [Date, nil]
  attr_accessor :since
  # 終了日
  #
  # 名称はGoogle検索に準拠している。
  # @return [Date, nil]
  attr_accessor :until

  # ページ番号
  # @return [Integer]
  attr_accessor :page

  validates(:query, presence: true)
  validates(:channel,
            presence: true,
            inclusion: { in: Channel.pluck(:identifier) })
  validates(
    :page,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1
    }
  )

  validate :until_must_not_be_less_than_since_if_both_exist

  before_validation :correct_page

  # 開始日を設定する
  #
  # Date型に変換できないときはnilになる。
  # @param [#to_date] value 開始日
  def since=(value)
    begin
      @since = value.to_date
    rescue
      @since = nil
    end
  end

  # 終了日を設定する
  #
  # Date型に変換できないときはnilになる。
  # @param [#to_date] value 終了日
  def until=(value)
    begin
      @until = value.to_date
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
      'query' => @query,
      'channel' => @channel,
      'since' => @since,
      'until' => @until,
      'page' => @page
    }
  end

  # 指定したハッシュを使って属性を設定する
  # @param [Hash] hash 属性の設定に使うハッシュ
  # @return [Hash] 指定したハッシュ
  def attributes=(hash)
    self.query = hash['query']
    self.channel = hash['channel']
    self.since = hash['since']
    self.until = hash['until']
    self.page = hash['page']

    hash
  end

  # 結果ページ向けの属性のハッシュを返す
  # @return [Hash]
  def attributes_for_result_page
    {
      'q' => @query,
      'channel' => @channel,
      'since' => @since,
      'until' => @until,
      'page' => @page
    }
  end

  # 結果ページのパラメータのハッシュを使って属性を設定する
  # @param [Hash] hash 属性の設定に使うハッシュ
  # @return [Hash] 指定したハッシュ
  def set_attributes_from_result_page_params(params)
    self.query = params['q']
    self.channel = params['channel']
    self.since = params['since']
    self.until = params['until']
    self.page = params['page']
  end

  # 検索結果を返す
  # @return [MessageSearchResult] 検索結果
  # @return [nil] 属性が正しくなかった場合
  def result
    return nil unless valid?

    messages = ConversationMessage.all
    messages = ConversationMessage.
      includes(:channel).
      page(@page)

    if @since.present?
      messages = messages.where('timestamp >= ?', @since)
    end

    if @until.present?
      messages = messages.where('timestamp <= ?', @until)
    end

    channel = Channel.find_by(identifier: @channel)
    messages = messages.
      select('DATE(timestamp) AS date',
             :type,
             :id,
             :channel_id,
             :irc_user_id,
             :timestamp,
             :nick,
             :message).
      where(channel: channel).
      full_text_search(@query).
      order(timestamp: :desc).
      page(@page).
      includes(:channel)
    message_groups = messages.group_by(&:date)

    MessageSearchResult.new(channel, messages, message_groups)
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
