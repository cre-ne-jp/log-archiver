class Admin::ConversationMessagesController < ApplicationController
  before_action(:require_login)

  def index
  end

  def show
    @conversation_message = ConversationMessage.find(params[:id])
    @browse_day = ChannelBrowse::Day.new(
      channel: @conversation_message.channel, date: @conversation_message.timestamp, style: :normal
    )

  end

  def edit
  end

  def update
  end

  def update
  end
end
