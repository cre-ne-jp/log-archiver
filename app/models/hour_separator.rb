# 生ログの1時間ごとの区切りのモデル
class HourSeparator
  attr_reader :timestamp

  def initialize(date, hour)
    @timestamp = Time.zone.local(date.year, date.month, date.day, hour)
  end

  def fragment_id
    @timestamp.strftime('%H%M%S')
  end
end
