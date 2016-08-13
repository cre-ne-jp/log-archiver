class Part < Message
  # Tiarra のログ形式の文字列を返す
  # @return [String]
  def to_tiarra_format
    common_part =
      "#{timestamp.strftime('%T')} - #{nick} " \
      "from #{channel.name_with_prefix}"

    message.blank? ? common_part : "#{common_part} (#{message})"
  end
end
