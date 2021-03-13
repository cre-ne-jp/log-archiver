class Notice < ConversationMessage
  include MessageStimulusTarget::Speech

  validates :message, length: { minimum: 1 }

  # Tiarra のログ形式の文字列を返す
  # @return [String]
  def to_tiarra_format
    "#{timestamp.strftime('%T')} " \
      "(#{channel.name_with_prefix}:#{nick}) #{message}"
  end
end
