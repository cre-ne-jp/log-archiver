class Topic < ConversationMessage
  # Tiarra のログ形式の文字列を返す
  # @return [String]
  def to_tiarra_format
    "#{timestamp.strftime('%T')} Topic of " \
      "channel #{channel.name_with_prefix} " \
      "by #{nick}: #{message}"
  end
end
