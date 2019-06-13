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

    # 時分秒の文字列
    hms_str = '%02d:%02d:%02d' % [hour, min, sec]

    # 1日以上だったら日数も加える
    # 1日未満だったら時分秒のみ
    day > 0 ? "#{day}日 #{hms_str}" : hms_str
  end
end
