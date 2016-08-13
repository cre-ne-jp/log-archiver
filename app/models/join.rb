class Join < Message
  # Tiarra のログ形式の文字列を返す
  # @return [String]
  def to_tiarra_format
    "#{timestamp.strftime('%T')} + #{nick} " \
    "(#{irc_user.mask(nick)}) to #{channel.name_with_prefix}"
  end
end
