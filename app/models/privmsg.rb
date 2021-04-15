class Privmsg < ConversationMessage
  include MessageStimulusTarget::Speech

  has_one :privmsg_keyword_relationship, dependent: :destroy
  has_one :keyword, through: :privmsg_keyword_relationship

  validates :message, length: { minimum: 1 }

  # Tiarra のログ形式の文字列を返す
  # @return [String]
  def to_tiarra_format
    "#{timestamp.strftime('%T')} " \
      "<#{channel.name_with_prefix}:#{nick}> #{message}"
  end
end
