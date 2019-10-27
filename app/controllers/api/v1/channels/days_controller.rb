# frozen_string_literal: true

class Api::V1::Channels::DaysController < ApiController
  def index
    channel = Channel.friendly.find(params[:id])

    year = params[:year].to_i
    month = params[:month].to_i

    start_date = Date.new(year, month, 1)
    date_range = start_date...(start_date.next_month)

    sql_date_timestamp = Arel.sql('DATE(timestamp)')
    speech_count = ConversationMessage.
      where(timestamp: date_range,
            channel: channel,
            type: %w(Privmsg Notice)).
      group(sql_date_timestamp).
      order(sql_date_timestamp).
      count

    render(json: {
      query: {
        year: year,
        month: month,
        channel_identifier: channel.identifier
      },
      response: {
        channel_name: channel.name,
        speech_count: speech_count
      }
    })
  end

  def show
    channel = Channel.friendly.find(params[:id])

    year = params[:year].to_i
    month = params[:month].to_i
    day = params[:day].to_i
    date = Date.new(year, month, day)

    timestamp_range = date...(date.next_day)
    messages = Message.
      includes(:channel, :irc_user).
      where(timestamp: timestamp_range, channel: channel).
      order(:timestamp, :id).
      to_a
    conversation_messages = ConversationMessage.
      includes(:channel, :irc_user).
      where(timestamp: timestamp_range, channel: channel).
      order(:timestamp, :id).
      to_a

    whole_messages = (messages + conversation_messages).map do |m|
      common = {
        type: m.class.to_s,
        nick: m.nick,
        user: m.irc_user.user,
        host: m.irc_user.host,
        channel: m.channel.name_with_prefix,
        timestamp: m.timestamp,
        digest: m.fragment_id
      }

      body = case(m)
        when Join
          {}
        when Part, Quit
          {message: m.message}
        when Nick
          {new_nick: m.new_nick}
        when Kick
          {
            target: m.target,
            message: m.message
          }
        when Topic, Privmsg, Notice
          {message: m.message}
        end

      common.merge(body)
    end

    # タイムスタンプによるソート
    # 安定ソートとなるようにカウンタを用意する
    i = 0
    sorted_messages = whole_messages.sort_by { |m| [m[:timestamp], i += 1] }

    render(json: {
      query: {
        year: year,
        month: month,
        day: day,
        channel_identifier: channel.identifier
      },
      response: {
        channel_name: channel.name,
        messages: sorted_messages
      }
    })
  end
end
