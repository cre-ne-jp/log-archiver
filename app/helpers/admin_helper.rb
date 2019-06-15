module AdminHelper
  # 稼働時間を整形する
  # @param [Float] length_s 秒単位の稼働時間
  # @return [String] 整形後の稼働時間
  def format_uptime(length_s)
    # 日数、残りの秒数を求める
    # 24時間/日 * 60分/時間 * 60秒/分 = 86400秒/日
    day, rest_hms = length_s.divmod(86400)

    # 時間、残りの秒数を求める
    # 60分/時間 * 60秒/分 = 3600秒/時間
    hour, rest_ms = rest_hms.divmod(3600)

    # 分、秒を求める
    min, sec = rest_ms.divmod(60)

    '%d:%02d:%02d:%02d' % [day, hour, min, sec]
  end
end
