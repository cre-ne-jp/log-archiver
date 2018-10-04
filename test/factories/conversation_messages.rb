FactoryBot.define do
  factory :conversation_message do
    channel
    irc_user
    type { 'Privmsg' }
    timestamp { "2016-11-29 00:42:49" }
    nick { 'rgrb' }
    message { 'Hello world' }

    # タイムスタンプは 100 -> 400 -> 200 の順に新しい
    factory :message_100 do
      association :channel, factory: :channel_100
      timestamp { '2017-01-23 01:23:45 +0900' }
    end

    factory :message_200 do
      association :channel, factory: :channel_200
      timestamp { '2016-12-31 12:34:56 +0900' }
    end

    factory :message_400 do
      association :channel, factory: :channel_400
      timestamp { '2017-01-02 00:01:23 +0900' }
    end
  end
end
