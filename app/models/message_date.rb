class MessageDate < ActiveRecord::Base
  belongs_to :channel
  validates :channel, presence: true
  validates :date, presence: true
end
