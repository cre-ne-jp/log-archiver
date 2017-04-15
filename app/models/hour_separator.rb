# 生ログの 1 時間ごとの区切りのモデル
class HourSeparator
  attr_reader :timestamp

  # 1 時間ごとの区切りを初期化する
  # @param [Date] date 日付
  # @param [Integer] hour 時
  # @raise [ArgumentError] hour が 0〜23 の整数でない場合
  def initialize(date, hour)
    unless hour.kind_of?(Integer) && (0...24).include?(hour)
      raise ArgumentError, "invalid hour: #{hour}"
    end

    @timestamp = Time.zone.local(date.year, date.month, date.day, hour)
  end

  # HTML のフラグメント識別子を返す
  # @return [String]
  def fragment_id
    @timestamp.strftime('%H%M%S')
  end
end
