FactoryBot.define do
  factory :kick do
    channel
    irc_user
    timestamp { '2016-04-01 12:35:00 +0900' }
    nick { 'ocha' }
    target { 'rgrb' }
    message { '暴走したので KICK' }

    factory :kick_role_bar_20140320123500 do
      association :irc_user, factory: :irc_user_role
      timestamp { '2014-03-20 12:35:00 +0900' }
      nick { 'Role' }
      target { 'bar' }
    end
  end
end
