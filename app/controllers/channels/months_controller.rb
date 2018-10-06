class Channels::MonthsController < ApplicationController
  include NavLinkSettable

  def index
    target_channels, @other_channels = Channel.
      order_for_list.
      partition { |channel| channel.identifier == params[:id] }
    @channel = target_channels.first

    @year = params[:year].to_i

    browse_year = ChannelBrowse::Year.new(channel: @channel, year: @year)
    @browse_prev_year = browse_year.prev_year
    @browse_next_year = browse_year.next_year

    set_prev_link!(@browse_prev_year)
    set_next_link!(@browse_next_year)

    start_date = Date.new(@year, 1, 1)
    @month_count = MessageDate.
      distinct.
      where(channel: @channel,
            date: start_date...(start_date.next_year)).
      group('MONTH(date)').
      order(:date).
      count

    @years = MessageDate.years(@channel)
  end
end
