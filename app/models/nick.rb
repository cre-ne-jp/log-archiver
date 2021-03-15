class Nick < Message
  include MessageStimulusTarget::Nick

  validates :message, presence: true

  # 新しいニックネームを返す
  # @return [String]
  def new_nick
    message
  end

  # 新しいニックネームを設定する
  # @param [String] value 新しいニックネーム
  # @return [String]
  def new_nick=(value)
    self.message = value
  end

  # Tiarra のログ形式の文字列を返す
  # @return [String]
  def to_tiarra_format
    "#{timestamp.strftime('%T')} #{nick} -> #{new_nick}"
  end

  # @return [Boolean] 参加中の全チャンネルに同時に送られるメッセージか？
  def broadcast?
    true
  end
end
