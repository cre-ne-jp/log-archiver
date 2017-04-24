# チャンネルのある日付（年月日）の閲覧を表すクラス
class ChannelBrowse::Day
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  extend SimpleEnum::Attribute

  # チャンネル
  # @return [Channel]
  attr_accessor :channel
  # 日付
  # @return [Date]
  attr_accessor :date
  # 表示のスタイル
  #
  # * normal: 通常
  # * raw: 生ログ
  attr_accessor :style_cd
  as_enum(:style, %i{normal raw}, prefix: :is_style)

  validates(:channel, presence: true)
  validates(:date, presence: true)
  validates(:style, presence: true)

  def initialize(*)
    self.style = :normal
    super
  end

  # 今日のログの閲覧を返す
  # @param [Channel] channel チャンネル
  # @param [Symbol] style 表示のスタイル
  # @return [ChannelBrowse::Day]
  def self.today(channel, style: :normal)
    new(channel: channel, date: Time.current.to_date, style: style)
  end

  # 昨日のログの閲覧を返す
  # @param [Channel] channel チャンネル
  # @param [Symbol] style 表示のスタイル
  # @return [ChannelBrowse::Day]
  def self.yesterday(channel, style: :normal)
    new(channel: channel, date: Time.current.to_date.prev_day, style: style)
  end

  # 日付を設定する
  #
  # value を日付に変換できないときは nil になる。
  # @param [#to_date] value 日付
  def date=(value)
    begin
      @date = value.to_date
    rescue
      @date = nil
    end
  end

  # メッセージが記録されている前の日の閲覧を返す
  # @return [ChannelBrowse::Day] メッセージが記録されている前の日の閲覧
  # @return [nil] 属性が無効、またはメッセージが記録されている最初の日だった場合
  def prev_day
    return nil unless valid?

    prev_message_date = MessageDate.
      where(channel: @channel).
      where('date < ?', date).
      order(date: :desc).
      first

    return nil unless prev_message_date

    browse_day = self.dup
    browse_day.date = prev_message_date.date

    browse_day
  end


  # メッセージが記録されている次の日の閲覧を返す
  # @return [ChannelBrowse::Day] メッセージが記録されている次の日の閲覧
  # @return [nil] 属性が無効、またはメッセージが記録されている最後の日だった場合
  def next_day
    return nil unless valid?

    next_message_date = MessageDate.
      where(channel: @channel).
      where('date > ?', date).
      order(:date).
      first

    return nil unless next_message_date

    browse_day = self.dup
    browse_day.date = next_message_date.date

    browse_day
  end

  # URLを求める際に使うパラメータのハッシュを返す
  # @return [Hash] URLを求める際に使うパラメータのハッシュ
  # @return [nil] 属性が無効な場合
  def params_for_url
    return nil unless valid?

    params = {
      year: @date.year.to_s,
      month: '%02d' % @date.month,
      day: '%02d' % @date.day
    }
    style_params = (style == :normal) ? {} : { style: style.to_s }

    params.merge(style_params)
  end

  # ログ閲覧ページのパスを返す
  # @param [Hash] params 追加のパラメータ
  # @return [String] ログ閲覧ページのパス
  # @return [nil] 属性が無効な場合
  def path(params = {})
    return nil unless valid?

    Rails.application.routes.url_helpers.channels_day_path(
      @channel, params_for_url.merge(params)
    )
  end

  # ログ閲覧ページの URL を返す
  # @param [String] host ホスト名。スキーム付きでもよい
  # @param [Hash] params 追加のパラメータ
  # @return [String] ログ閲覧ページの URL
  # @return [nil] 属性が無効な場合
  def url(host, params = {})
    return nil unless valid?

    Rails.application.routes.url_helpers.channels_day_url(
      @channel,
      params_for_url.merge(params).merge({ host: host })
    )
  end
end
