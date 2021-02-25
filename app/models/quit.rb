class Quit < Message
  # Tiarra のログ形式の文字列を返す
  # @return [String]
  def to_tiarra_format
    "#{timestamp.strftime('%T')} ! #{nick} (#{message})"
  end

  # @return [Boolean] 参加中の全チャンネルに同時に送られるメッセージか？
  def broadcast?
    true
  end
end
