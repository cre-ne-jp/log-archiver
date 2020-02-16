class Admin::Channels::ConversationMessagesController < ApplicationController
  include MessageHelper

  before_action(:require_login)

  def show
    @conversation_message = ConversationMessage.find(params[:conversation_message_id])
    @channel = @conversation_message.channel
    @date = @conversation_message.timestamp

    # 実質的にページを指定するのは ConversationMessage.id とする
    # パスで指定されたチャンネル識別子・日付が間違っていたら、正しいページに転送する
    if !(@channel.identifier == params[:id] && @date.year == params[:year].to_i && @date.month == params[:month].to_i && @date.day == params[:day].to_i)
      redirect_to(admin_conversation_message_path(@conversation_message))
    end

    @archived_conversation_message = ArchivedConversationMessage.from_conversation_message(@conversation_message)
    @archive_reasons = ArchiveReason.all

    @browse_year = ChannelBrowse::Year.new(channel: @channel, year: @date.year)
    @browse_month = ChannelBrowse::Month.new(channel: @channel, year: @date.year, month: @date.month)
    @browse_day = ChannelBrowse::Day.new(channel: @channel, date: @date, style: :normal)
  end
end
