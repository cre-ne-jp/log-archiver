FactoryBot.define do
  factory :nick do
    channel
    irc_user
    timestamp { '2016-04-01 12:35:01 +0900' }
    nick { 'rgrb' }
    message { 'rgrb2' }

    factory :nick_foo_bar_20140320012354 do
      timestamp { '2014-03-20 01:23:54 +0900' }
      nick { 'foo' }
      message { 'bar' }
    end

    # 期間指定用
    # 同時刻ならば1つにまとめられる

    factory :nick_role_channel_100_20200320023501 do
      association :channel, factory: :channel_100
      association :irc_user, factory: :irc_user_role
      timestamp { '2020-03-20 02:35:01 +0900' }
      nick { 'Role' }
      message { 'Role2' }
    end

    factory :nick_role_channel_200_20200320023501 do
      association :channel, factory: :channel_200
      association :irc_user, factory: :irc_user_role
      timestamp { '2020-03-20 02:35:01 +0900' }
      nick { 'Role' }
      message { 'Role2' }
    end
  end
end
