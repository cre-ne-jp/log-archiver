FactoryGirl.define do
  factory :quit do
    channel
    irc_user
    timestamp '2016-04-01 12:34:59'
    nick 'rgrb'
    message 'Bye!'
  end
end
