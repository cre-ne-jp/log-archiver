class ConversationMessage < ActiveRecord::Base
  belongs_to :channel
  belongs_to :irc_user

  enum command: {
    privmsg: 0,
    notice: 1,
    topic: 2
  }

  scope :full_text_search, ->(query) {
    where('MATCH(message) AGAINST(? IN BOOLEAN MODE)', "*D+ #{query}")
  }
end
