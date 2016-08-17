class Channels::DaysController < ApplicationController
  def index
    @channel = Channel.find_by(identifier: params[:identifier])
    @year = params[:year].to_i
    @month = params[:month].to_i

    start_date = Date.new(@year, @month, 1)
    @day_count = Message.
      uniq.
      where(channel: @channel,
            type: %w(Privmsg Notice),
            timestamp: start_date...(start_date.next_month)).
      group('DATE(timestamp)').
      order(:timestamp).
      count
  end

  def show
    target_channels, @other_channels = Channel.all.partition { |channel|
      channel.identifier == params[:identifier]
    }
    @channel = target_channels.first


    @year = params[:year].to_i
    @month = params[:month].to_i
    @day = params[:day].to_i
    @date = Date.new(@year, @month, @day)

    @calendar_start_date = params[:start_date]&.to_date || @date rescue @date

    @messages = Message.
      where(channel: @channel,
            timestamp: @date...(@date.next_day)).
      order(:timestamp, :id)
    @message_dates = MessageDate.where(channel: @channel)

  end
end
