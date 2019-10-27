# frozen_string_literal: true

class Api::V1::ChannelsController < ApiController
  def index
    channels = Channel.for_channels_index.map do |c|
      {
        name: c.name,
        identifier: c.identifier,
        logging_enabled: c.logging_enabled
      }
    end

    render(json: channels)
  end

  def show
    channel = Channel.friendly.find(params[:id])

    latest_topic = Topic.
      where(channel: channel).
      order(timestamp: :desc).
      limit(1).
      first

    unless latest_topic.nil?
      latest_topic = {
        timestamp: latest_topic.timestamp,
        nick: latest_topic.nick,
        user: latest_topic.irc_user.user,
        host: latest_topic.irc_user.host,
        fragment: latest_topic.fragment_id,
        message: latest_topic.message
      }
    end

    years = MessageDate.
      where(channel: channel).
      group(:year).
      order(Arel.sql('EXTRACT(YEAR FROM date)')).
      pluck(Arel.sql('EXTRACT(YEAR FROM date) AS year'))

    render(json: {
      query: {
        channel_identifier: channel.identifier
      },
      response: {
        channel_name: channel.name,
        latest_topic: latest_topic,
        years: years
      }
    })
  end
end
