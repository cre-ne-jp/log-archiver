# チャンネルのある日付（年月日）の閲覧を表すクラス
class ChannelBrowse::Day
  include ActiveModel::Model

  # チャンネル
  # @return [Channel]
  attr_accessor :channel
  # 日付
  # @return [Date]
  attr_accessor :date

  validates(:channel, presence: true)
  validates(:date, presence: true)

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

    {
      identifier: @channel&.identifier,
      year: @date.year.to_s,
      month: '%02d' % @date.month,
      day: '%02d' % @date.day
    }
  end
end
