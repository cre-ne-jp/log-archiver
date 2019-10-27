# frozen_string_literal: true

class Api::V1::Channels::MonthsController < ApiController
  def index
    channel = Channel.friendly.find(params[:id])

    year = params[:year].to_i

    start_date = Date.new(year, 1, 1)
    sql_extract_month_from_date = Arel.sql('EXTRACT(MONTH FROM date)')
    month_count = MessageDate.
      where(channel: channel,
            date: start_date...(start_date.next_year)).
      group(sql_extract_month_from_date).
      order(sql_extract_month_from_date).
      count

    render(json: {
      query: {
        year: year,
        channel_identifier: channel.identifier
      },
      response: {
        channel_name: channel.name,
        month_count: month_count
      }
    })
  end
end
