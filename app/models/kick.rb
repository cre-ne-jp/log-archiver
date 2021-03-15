class Kick < Message
  include MessageStimulusTarget::JoinPart

  validates :target, presence: true

  # Tiarra のログ形式の文字列を返す
  # @return [String]
  def to_tiarra_format
    "#{timestamp.strftime('%T')} - #{target} by #{nick} " \
    "from #{channel.name_with_prefix} (#{message})"
  end
end
