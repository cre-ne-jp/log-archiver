class ConversationMessage < ActiveRecord::Base
  belongs_to :channel
  belongs_to :irc_user

  scope :full_text_search, ->(query) {
    where('MATCH(message) AGAINST(? IN BOOLEAN MODE)', "*D+ #{query}")
  }
end
