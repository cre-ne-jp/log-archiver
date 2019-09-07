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
  end
end
