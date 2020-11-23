FactoryBot.define do
  factory :quit do
    channel
    irc_user
    timestamp { '2016-04-01 12:34:59 +0900' }
    nick { 'rgrb' }
    message { 'Bye!' }

    factory :quit_role_channel_100_20200320024001 do
      association :channel, factory: :channel_100
      association :irc_user, factory: :irc_user_role
      timestamp { '2020-03-20 02:40:01 +0900' }
      nick { 'Role' }
    end

    factory :quit_role_channel_200_20200320024001 do
      association :channel, factory: :channel_200
      association :irc_user, factory: :irc_user_role
      timestamp { '2020-03-20 02:40:01 +0900' }
      nick { 'Role' }
    end

    factory :quit_rgrb_channel_100_20200321112233 do
      association :channel, factory: :channel_100
      timestamp { '2020-03-21 11:22:33 +0900' }
    end
  end
end
