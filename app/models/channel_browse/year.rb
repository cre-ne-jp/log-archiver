# チャンネルのある年の閲覧を表すクラス
class ChannelBrowse::Year
  include ActiveModel::Model

  # チャンネル
  # @return [Channel]
  attr_accessor :channel
  # 年
  # @return [Integer]
  attr_accessor :year

  validates(:channel, presence: true)
  validates(
    :year,
    presence: true,
    numericality: {
      only_integer: true
    }
  )

  # URLを求める際に使うパラメータのハッシュを返す
  # @return [Hash] URLを求める際に使うパラメータのハッシュ
  # @return [nil] 属性が無効な場合
  def params_for_url
    return nil unless valid?

    {
      year: @year.to_s
    }
  end

  # 年のページのパスを返す
  # @param [Hash] params 追加のパラメータ
  # @return [String] 年のページのパス
  # @return [nil] 属性が無効な場合
  def path(params = {})
    return nil unless valid?

    Rails.application.routes.url_helpers.channels_months_path(
      @channel, params_for_url.merge(params)
    )
  end

  # 年のページの URL を返す
  # @param [String] host ホスト名。スキーム付きでもよい
  # @param [Hash] params 追加のパラメータ
  # @return [String] 年のページの URL
  # @return [nil] 属性が無効な場合
  def url(host, params = {})
    return nil unless valid?

    Rails.application.routes.url_helpers.channels_months_url(
      @channel,
      params_for_url.merge(params).merge({ host: host })
    )
  end
end
