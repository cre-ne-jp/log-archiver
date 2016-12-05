class WelcomeController < ApplicationController
  def index
    @channels = Channel.select(:id, :identifier, :name)
    @channel_data_for_select = [['全チャンネル', -1]] +
      @channels.map { |channel| [channel.name_with_prefix, channel.id] }
    @today = Time.now.to_date
    @yesterday = @today.prev_day

    today_range = @today...(@today.next_day)
    yesterday_range = (@yesterday.prev_day)...@yesterday

    @conversation_messages_count_today = ConversationMessage.
      where(timestamp: today_range).
      group(:channel_id).
      count
    @conversation_messages_count_yesterday = ConversationMessage.
      where(timestamp: yesterday_range).
      group(:channel_id).
      count
  end
end
