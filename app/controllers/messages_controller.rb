class MessagesController < ApplicationController
  def index
    channel_identifier = params['channel']
    @channel = Channel.find_by(identifier: channel_identifier)
    unless @channel
      raise ArgumentError, "Channel #{channel_identifier} was not found."
    end

    @messages = ConversationMessage.includes(:channel)

    @keyword = params['keyword']
    if @keyword.present?
      @messages = @messages.full_text_search(@keyword)
    end

    @since = params['since']
    if @since.present?
      @messages = @messages.where('timestamp >= ?', @since)
    end

    @until = params['until']
    if @until.present?
      @messages = @messages.where('timestamp <= ?', @until)
    end

    @messages = @messages.
      where(channel: @channel).
      order(:timestamp).
      limit(1000).
      to_a
    @message_groups = @messages.
      group_by { |message| message.timestamp.to_date }.
      sort_by { |date, _| date }.
      reverse
  end
end
