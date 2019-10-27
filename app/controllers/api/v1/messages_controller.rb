# frozen_string_literal: true

class Api::V1::MessagesController < ApiController
  def show
    fragment_id = params[:id]
    unless query = fragment_id.match(/\A([cm])([\da-f]{8})\z/)
      response_bad_request('Fragment ID is broken.')
      return
    end

    type = case(query[1])
      when 'c'
        ConversationMessage
      when 'm'
        Message
      end
    digest = query[2]

    messages = type.
      where(digest: "fnv1a32:#{digest}").
      map do |m|
        {
          channel_name: m.channel.name,
          timestamp: m.timestamp,
          nick: m.nick,
          user: m.irc_user.user,
          host: m.irc_user.host,
          message: m.message
        }
      end

    render(json: {
      query: {
        fragment_id: fragment_id,
        type: type.to_s,
        digest: digest
      },
      response: messages
    })
  end
end
