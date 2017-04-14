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

    @browse_day = ChannelBrowse::Day.new(channel: @channel, date: @date)
    @browse_prev_day = ChannelBrowse::Day.new(channel: @channel, date: @date.prev_day)
    @browse_next_day = ChannelBrowse::Day.new(channel: @channel, date: @date.next_day)

    @browse_year = ChannelBrowse::Year.new(channel: @channel, year: @date.year)
    @browse_month = ChannelBrowse::Month.new(channel: @channel, year: @date.year, month: @date.month)

    @calendar_start_date = (params[:start_date]&.to_date || @date) rescue @date

    timestamp_range = @date...(@date.next_day)
    messages = Message.
      includes(:channel, :irc_user).
      where(channel: @channel, timestamp: timestamp_range).
      order(:timestamp, :id).
      to_a
    @conversation_messages = ConversationMessage.
      includes(:channel, :irc_user).
      where(channel: @channel, timestamp: timestamp_range).
      order(:timestamp, :id).
      to_a

    @list_style = (params[:style] == 'raw') ? :raw : :normal
    whole_messages =
      if @list_style == :raw
        hour_separators = (0...24).map { |hour|
          HourSeparator.new(@date, hour)
        }

        hour_separators + messages + @conversation_messages
      else
        messages + @conversation_messages
      end

    # タイムスタンプによるソート
    # 安定ソートとなるようにカウンタを用意する
    i = 0
    @sorted_messages = whole_messages.
      sort_by { |m| [m.timestamp, i += 1] }

    @message_dates = MessageDate.where(channel: @channel)

    @day_link_params = (@list_style == :raw) ? { style: 'raw' } : {}
  end
end
