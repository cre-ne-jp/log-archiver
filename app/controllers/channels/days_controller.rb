class Channels::DaysController < ApplicationController
  def index
    @channel = Channel.find_by(identifier: params[:identifier])
    @year = params[:year].to_i
    @month = params[:month].to_i

    start_date = Date.new(@year, @month, 1)
    date_range = start_date...(start_date.next_month)
    @dates = MessageDate.
      where(channel: @channel,
            date: date_range).
      order(:date).
      pluck(:date)
    @speech_count = ConversationMessage.
      uniq.
      where(channel: @channel,
            type: %w(Privmsg Notice),
            timestamp: date_range).
      group('DATE(timestamp)').
      order(:timestamp).
      count
  end

  def show
    target_channels, @other_channels = Channel.
      order_for_list.
      partition { |channel|
        channel.identifier == params[:identifier]
      }
    @channel = target_channels.first

    @year = params[:year].to_i
    @month = params[:month].to_i
    @day = params[:day].to_i
    @date = Date.new(@year, @month, @day)

    @calendar_start_date = (params[:start_date]&.to_date || @date) rescue @date

    timestamp_range = @date...(@date.next_day)
    messages1 = Message.
      includes(:channel, :irc_user).
      where(channel: @channel, timestamp: timestamp_range).
      order(:timestamp, :id)
    messages2 = ConversationMessage.
      includes(:channel, :irc_user).
      where(channel: @channel, timestamp: timestamp_range).
      order(:timestamp, :id)

    # タイムスタンプによるソート
    # 安定ソートとなるようにカウンタを用意する
    i = 0
    @messages = (messages1 + messages2).
      sort_by { |m| [m.timestamp, i += 1] }

    @message_dates = MessageDate.where(channel: @channel)
  end
end
