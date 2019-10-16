class PrivmsgKeywordRelationship < ApplicationRecord
  belongs_to :privmsg
  belongs_to :keyword

  validates :privmsg_id, presence: true
  validates :keyword_id, presence: true

  scope :from_privmsgs, ->privmsgs {
    includes(:keyword)
      .where(privmsg: privmsgs)
  }
end
