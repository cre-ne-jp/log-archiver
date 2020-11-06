class Message < ApplicationRecord
  include MessageDigest

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
    refresh_digest_unless_exist!

    "m#{digest_value}"
  end
end
