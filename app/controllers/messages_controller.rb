class MessagesController < ApplicationController
  def index
    @messages = ConversationMessage.all

    query = params['query']
    if query.present?
      @messages = @messages.full_text_search(query)
    end
  end
end
