class Channels::MonthsController < ApplicationController
  def index
    @channel = Channel.find_by(identifier: params[:identifier])
    @year = params[:year].to_i

    start_date = Date.new(@year, 1, 1)
    @month_count = MessageDate.
      uniq.
      where(channel: @channel,
            date: start_date...(start_date.next_year)).
      group('MONTH(date)').
      order(:date).
      count
  end
end
