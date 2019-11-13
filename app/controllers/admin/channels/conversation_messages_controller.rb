class Admin::Channels::ConversationMessageController < ApplicationController
  before_action(:require_login)

  def show
    @conversation_message = ConversationMessage.find(params[:id])
    @browse_day = ChannelBrowse::Day.new(
      channel: @conversation_message.channel, date: @conversation_message.timestamp, style: :normal
    )
  end

  def edit
    @conversation_message = ConversationMessage.find(params[:id])
    @archived_conversation_message = ArchivedConversationMessage.from_conversation_message(@conversation_message)
    @archive_reasons = ArchiveReason.all
  end

  private

  def archived_conversation_message_params_for_create
    params.
      require(:archived_conversation_message).
      permit(:archive_reason_id, :old_id)
  end
end
