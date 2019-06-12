# vim: fileencoding=utf-8

module LogArchiver
  class Application
    BOOTED_AT = Time.now

    # 起動してからどれくらいの時間が経ったかを返す
    # @return [String]
    def self.uptime
      time_ago = Time.now - BOOTED_AT
      day, sec = time_ago.divmod(86400)
      (Time.parse('1/1') + sec).strftime("#{day}:%H:%M:%S")
    end
  end
end
