class Privmsg < Message
  validates :message, presence: true
end
