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
      identifier: @channel&.identifier,
      year: @year.to_s
    }
  end
end
