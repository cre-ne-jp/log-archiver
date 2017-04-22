# チャンネルのある年月の閲覧を表すクラス
class ChannelBrowse::Month
  include ActiveModel::Model

  # チャンネル
  # @return [Channel]
  attr_accessor :channel
  # 年
  # @return [Integer]
  attr_accessor :year
  # 月
  # @return [Integer]
  attr_accessor :month

  validates(:channel, presence: true)
  validates(
    :year,
    presence: true,
    numericality: {
      only_integer: true
    }
  )
  validates(
    :month,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 12
    }
  )

  # URLを求める際に使うパラメータのハッシュを返す
  # @return [Hash] URLを求める際に使うパラメータのハッシュ
  # @return [nil] 属性が無効な場合
  def params_for_url
    return nil unless valid?

    {
      year: @year.to_s,
      month: '%02d' % @month,
    }
  end

  # 月のページのパスを返す
  # @param [Hash] params 追加のパラメータ
  # @return [String] ログ閲覧ページのパス
  # @return [nil] 属性が無効な場合
  def path(params = {})
    return nil unless valid?

    Rails.application.routes.url_helpers.channels_days_path(
      @channel, params_for_url.merge(params)
    )
  end

  # 月のページの URL を返す
  # @param [String] host ホスト名。スキーム付きでもよい
  # @param [Hash] params 追加のパラメータ
  # @return [String] ログ閲覧ページの URL
  # @return [nil] 属性が無効な場合
  def url(host, params = {})
    return nil unless valid?

    Rails.application.routes.url_helpers.channels_days_url(
      @channel,
      params_for_url.merge(params).merge({ host: host })
    )
  end

  # メッセージが記録されている前の月の閲覧を返す
  # @return [ChannelBrowse::Month] メッセージが記録されている前の月の閲覧
  # @return [nil] 属性が無効、またはメッセージが記録されている最初の月だった場合
  def prev_month
    return nil unless valid?

    prev_message_date = MessageDate.
      where(channel: @channel).
      where('date < ?', Date.new(@year, @month, 1)).
      order(date: :desc).
      first

    return nil unless prev_message_date

    date = prev_message_date.date
    self.class.new(channel: @channel, year: date.year, month: date.month)
  end


  # メッセージが記録されている次の月の閲覧を返す
  # @return [ChannelBrowse::Month] メッセージが記録されている次の月の閲覧
  # @return [nil] 属性が無効、またはメッセージが記録されている最後の月だった場合
  def next_month
    return nil unless valid?

    next_message_date = MessageDate.
      where(channel: @channel).
      where('date >= ?', Date.new(@year, @month, 1).next_month).
      order(:date).
      first

    return nil unless next_message_date

    date = next_message_date.date
    self.class.new(channel: @channel, year: date.year, month: date.month)
  end
end
