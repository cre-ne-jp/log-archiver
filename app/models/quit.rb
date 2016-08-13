class Quit < Message
  # Tiarra のログ形式の文字列を返す
  # @return [String]
  def to_tiarra_format
    "#{timestamp.strftime('%T')} ! #{nick} (#{message})"
  end
end
