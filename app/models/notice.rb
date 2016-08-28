class Notice < Message
  validates :message, presence: true

  # Tiarra のログ形式の文字列を返す
  # @return [String]
  def to_tiarra_format
    "#{timestamp.strftime('%T')} " \
      "(#{channel.name_with_prefix}:#{nick}) #{message}"
  end
end
