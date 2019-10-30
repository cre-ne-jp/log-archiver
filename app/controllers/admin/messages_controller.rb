class Admin::MessagesController < ApplicationController
  before_action(:require_login)

  def show
    unless query = params[:fragment_id].match(/\A([acm])([\da-f]{8})\z/)
      render status: 400
    end

    type = case(query[1])
      when 'c'
        ConversationMessage
      when 'm'
        Message
      when 'a'
        ArchivedConversationMessage
      end
    digest = query[2]

    messages = type.where(digest: "fnv1a32:#{digest}")
    render json: messages
  end

  def update
  end

  def update
  end
end
