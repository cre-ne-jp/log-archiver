class ConversationMessage < ActiveRecord::Base
  belongs_to :channel
  belongs_to :irc_user

  validates :channel, presence: true
  validates :timestamp, presence: true
  validates :nick,
    presence: true,
    length: { maximum: 64 }
  validates :message, length: { maximum: 512 }

  scope :nick_search, ->(nick) {
    where('MATCH(nick) AGAINST(? IN BOOLEAN MODE)', "*D+ #{nick}")
  }

  scope :full_text_search, ->(query) {
    where('MATCH(message) AGAINST(? IN BOOLEAN MODE)', "*D+ #{query}")
  }

  # URLのフラグメント識別子を返す
  # @return [String]
  def fragment_id
    "c#{id}"
  end
end
