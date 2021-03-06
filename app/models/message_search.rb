# メッセージのキーワード検索のモデル
class MessageSearch
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  # メッセージ検索の結果
  MessageSearchResult = Struct.new(:channels, :messages, :message_groups)

  # 検索文字列
  # @return [String]
  attr_accessor :query
  # ニックネーム
  # @return [String]
  attr_accessor :nick
  # チャンネル識別子
  #
  # パラメータ名の都合で名前がchannelsでも識別子を表すことに注意。
  # @return [Array<String>]
  attr_accessor :channels
  # 開始日
  # @return [Date, nil]
  #
  # 名称はGoogle検索に準拠している。
  #
  # セッターでは、Date型に変換できないときはnilになる。
  attr_reader :since
  # 終了日
  # @return [Date, nil]
  #
  # 名称はGoogle検索に準拠している。
  #
  # セッターでは、Date型に変換できないときはnilになる。
  attr_reader :until

  # ページ番号
  # @return [Integer]
  #
  # セッターでは、1以上でないときは1になる。
  attr_reader :page

  validates(:query_or_nick, presence: true)
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
      'nick' => @nick,
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
    self.query = hash['query']
    self.nick = hash['nick']
    self.channels = hash['channels']
    self.since = hash['since']
    self.until = hash['until']
    self.page = hash['page']
  end

  # 結果ページ向けの属性のハッシュを返す
  # @return [Hash]
  def attributes_for_result_page
    {
      'q' => @query,
      'nick' => @nick,
      'channels' => @channels.join(' '),
      'since' => @since&.strftime('%F'),
      'until' => @until&.strftime('%F'),
      'page' => @page
    }
  end

  # 結果ページのパラメータのハッシュを使って属性を設定する
  # @param [Hash] hash 属性の設定に使うハッシュ
  # @return [Hash] 指定したハッシュ
  def set_attributes_with_result_page_params(params)
    self.query = params['q']
    self.nick = params['nick']
    self.channels = params['channels']&.split(' ') || []
    self.since = params['since']
    self.until = params['until']
    self.page = params['page']
  end

  # 検索結果で必要な列
  MESSAGE_COLUMNS =
    %i(message nick type id channel_id irc_user_id timestamp digest).freeze

  # 検索結果を返す
  # @return [MessageSearchResult] 検索結果
  # @return [nil] 属性が正しくなかった場合
  def result
    return nil unless valid?

    channels = @channels.empty? ?
      [] : Channel.where(identifier: @channels).to_a

    messages = ConversationMessage.
      full_text_search(@query).
      filter_by_nick(@nick).
      filter_by_channels(channels).
      filter_by_since(@since).
      filter_by_until(@until).
      select(*MESSAGE_COLUMNS, 'DATE(timestamp) AS date').
      order(timestamp: :desc).
      page(@page).
      includes(:channel)

    MessageSearchResult.new(channels, messages, messages.group_by(&:date))
  end

  private

  # ページ番号を正しくする
  def correct_page
    @page = 1 if !@page || @page < 1
  end

  # 検索文字列またはニックネームが存在するか
  # @return [Boolean]
  def query_or_nick
    @query.presence || @nick.presence
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
