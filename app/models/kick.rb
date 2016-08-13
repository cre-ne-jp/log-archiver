class Kick < Message
  validates :target, presence: true
end
