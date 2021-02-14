FactoryBot.define do
  factory :part do
    channel
    irc_user
    timestamp { '2016-04-01 12:34:58 +0900' }
    nick { 'rgrb' }
    message { 'Bye!' }

    # 期間指定用
    # 複数のチャンネルに送られ得る
    # => 同時刻でもまとめられない

    factory :part_role_channel_100_20200320023601 do
      association :channel, factory: :channel_100
      association :irc_user, factory: :irc_user_role
      timestamp { '2020-03-20 02:36:01 +0900' }
      nick { 'Role' }
    end

    factory :part_role_channel_200_20200320023601 do
      association :channel, factory: :channel_200
      association :irc_user, factory: :irc_user_role
      timestamp { '2020-03-20 02:36:01 +0900' }
      nick { 'Role' }
    end
  end
end
