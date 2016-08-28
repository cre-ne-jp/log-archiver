FactoryGirl.define do
  factory :kick do
    channel
    irc_user
    timestamp '2016-04-01 12:35:00'
    nick 'ocha'
    target 'rgrb'
    message '暴走したので KICK'
  end
end
