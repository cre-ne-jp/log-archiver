FactoryGirl.define do
  factory :part do
    channel
    irc_user
    timestamp '2016-04-01 12:34:58 +0900'
    nick 'rgrb'
    message 'Bye!'
  end
end
