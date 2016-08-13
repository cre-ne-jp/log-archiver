class IrcUser < ActiveRecord::Base
  has_many :messages

  validates :name,
    presence: true,
    length: { maximum: 9 }
  validates :host, presence: true
end
