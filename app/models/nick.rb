class Nick < Message
  validates :message, presence: true

  def new_nick
    message
  end

  def new_nick=(value)
    self.message = value
  end
end
