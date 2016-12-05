class MessagesController < ApplicationController
  def index
    query = params['query']
    @messages =
      if query.present?
        ConversationMessage.full_text_search(query)
      else
        ConversationMessage.all
      end
    @messages = @messages.
      order(timestamp: :desc).
      limit(1000)
  end
end
