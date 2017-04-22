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
end
