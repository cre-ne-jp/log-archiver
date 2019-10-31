class Admin::ConversationMessagesController < ApplicationController
  before_action(:require_login)

  def index
  end

  def show
    if @conversation_message = ConversationMessage.where(id: params[:id]).first
      @browse_day = ChannelBrowse::Day.new(
        channel: @conversation_message.channel, date: @conversation_message.timestamp, style: :normal
      )
    elsif @conversation_message = ArchivedConversationMessage.where(old_id: params[:id]).first
      @browse_day = ChannelBrowse::Day.new(
        channel: @conversation_message.channel, date: @conversation_message.timestamp, style: :edit
      )
    end
  end

  def new
    @archived_conversation_message =
      ArchivedConversationMessage.new.attribute_by_conversation_message(
        ConversationMessage.find(params[:id])
      )
    @archive_reasons = ArchiveReason.all
  end

  def create
    archiver = ConversationMessageArchiver.new

    if am = archiver.archive!(archived_conversation_message_params_for_create)
      flash[:success] = t('views.flash.added_archived_conversation_message')
      redirect_to(admin_conversation_message_path(am.old_id))
    else
      render(:new)
    end
  end

  def edit
    @archived_conversation_message =
      ArchivedConversationMessage.find_by(old_id: params[:id])
    @archive_reasons = ArchiveReason.all
  end

  def update
    am = ArchivedConversationMessage.find_by(old_id: params[:id])

    if am.update(archived_conversation_message_params_for_update)
      flash[:success] = t('views.flash.updated_archived_conversation_message')
      redirect_to(admin_conversation_message_path(am.old_id))
    else
      render(:new)
    end
  end

  private

  def archived_conversation_message_params_for_create
    params.
      require(:archived_conversation_message).
      permit(:archive_reason_id, :old_id)
  end

  def archived_conversation_message_params_for_update
    params.
      require(:archived_conversation_message).
      permit(:archive_reason_id)
  end
end
