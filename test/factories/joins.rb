FactoryBot.define do
  factory :join do
    channel
    irc_user
    timestamp { '2016-04-01 12:34:57 +0900' }
    nick { 'rgrb' }

    factory :join_role_20140320023455 do
      association :irc_user, factory: :irc_user_role
      timestamp { '2014-03-20 02:34:55 +0900' }
      nick { 'Role' }
    end

    # 期間指定用
    # 複数のチャンネルに送られ得る
    # => 同時刻でもまとめられない

    factory :join_role_channel_100_20200320023455 do
      association :channel, factory: :channel_100
      association :irc_user, factory: :irc_user_role
      timestamp { '2020-03-20 02:34:55 +0900' }
      nick { 'Role' }
    end

    factory :join_role_channel_200_20200320023455 do
      association :channel, factory: :channel_200
      association :irc_user, factory: :irc_user_role
      timestamp { '2020-03-20 02:34:55 +0900' }
      nick { 'Role' }
    end

    # 以下、期間指定のQUITのテストで矛盾しないように
    # 再JOINする

    factory :join_role_channel_100_20200320023701 do
      association :channel, factory: :channel_100
      association :irc_user, factory: :irc_user_role
      timestamp { '2020-03-20 02:37:01 +0900' }
      nick { 'Role' }
    end

    factory :join_role_channel_200_20200320023730 do
      association :channel, factory: :channel_200
      association :irc_user, factory: :irc_user_role
      timestamp { '2020-03-20 02:37:30 +0900' }
      nick { 'Role' }
    end
  end
end
