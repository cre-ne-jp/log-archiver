class Message < ApplicationRecord
  include MessagesDigest

  before_save :add_digest

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
    "m#{digest_hash}"
  end
end
