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

  # URLを求める際に使うパラメータのハッシュを返す
  # @return [Hash] URLを求める際に使うパラメータのハッシュ
  # @return [nil] 属性が無効な場合
  def params_for_url
    return nil unless valid?

    params = {
      identifier: @channel&.identifier,
      year: @date.year.to_s,
      month: '%02d' % @date.month,
      day: '%02d' % @date.day
    }
    style_params = (style == :normal) ? {} : { style: style.to_s }

    params.merge(style_params)
  end
end
