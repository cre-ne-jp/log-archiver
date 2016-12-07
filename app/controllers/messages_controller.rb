class MessagesController < ApplicationController
  def index
    channel_identifier = params['channel']
    @channel = Channel.find_by(identifier: channel_identifier)
    unless @channel
      raise ArgumentError, "Channel #{channel_identifier} was not found."
    end

    page_int = params['page'].to_i
    page = page_int < 1 ? 1 : page_int
    @messages = ConversationMessage.includes(:channel).page(page)

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
      select('DATE(timestamp) AS date', :type,
             :id, :channel_id, :irc_user_id, :timestamp,
             :nick, :message).
      where(channel: @channel).
      order('date DESC', 'timestamp ASC')
    @message_groups = @messages.
      group_by { |message| message.date }.
      sort_by { |date, _| date }.
      reverse
  end
end
