class Message < ApplicationRecord
  include MessageDigest
  include MessageScope

  before_save :refresh_digest!

  belongs_to :channel
  belongs_to :irc_user

  validates :channel, presence: true
  validates :timestamp, presence: true
  validates :nick,
    presence: true,
    length: { maximum: 64 }
  validates :message, length: { maximum: 512 }

  # URLのフラグメント識別子を返す
  # @return [String]
  def fragment_id
    "m#{digest_value}"
  end

  # @return [Boolean] 参加中の全チャンネルに同時に送られるメッセージか？
  def broadcast?
    false
  end

  # 同じ同時配信メッセージかどうか判定する
  # @param [Message, nil] m 判定対象のメッセージ
  # @return [Boolean]
  def same_broadcast_message?(m)
    broadcast? &&
      m.class == self.class &&
      m.timestamp == timestamp &&
      m.irc_user_id == irc_user_id &&
      m.nick == nick &&
      m.message == message
  end
end
