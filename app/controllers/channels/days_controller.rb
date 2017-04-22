class Channels::DaysController < ApplicationController
  def index
    @channel = Channel.friendly.find(params[:id])
    @year = params[:year].to_i
    @month = params[:month].to_i

    browse_month = ChannelBrowse::Month.new(channel: @channel,
                                            year: @year,
                                            month: @month)
    @browse_prev_month = browse_month.prev_month
    @browse_next_month = browse_month.next_month

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
      partition { |channel| channel.identifier == params[:id] }
    @channel = target_channels.first

    @year = params[:year].to_i
    @month = params[:month].to_i
    @day = params[:day].to_i
    @date = Date.new(@year, @month, @day)

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

    @browse_day_normal = ChannelBrowse::Day.new(
      channel: @channel, date: @date, style: :normal
    )
    @browse_day_raw = ChannelBrowse::Day.new(
      channel: @channel, date: @date, style: :raw
    )

    @browse_day =
      (params[:style] == 'raw') ? @browse_day_raw : @browse_day_normal
    @browse_prev_day = @browse_day.prev_day
    @browse_next_day = @browse_day.next_day

    whole_messages =
      if @browse_day.is_style_raw?
        HourSeparator.for_day_browse(@date) + messages + @conversation_messages
      else
        messages + @conversation_messages
      end

    # タイムスタンプによるソート
    # 安定ソートとなるようにカウンタを用意する
    i = 0
    @sorted_messages = whole_messages.sort_by { |m| [m.timestamp, i += 1] }

    @message_dates = MessageDate.where(channel: @channel)
  end
end
