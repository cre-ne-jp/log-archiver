FactoryBot.define do
  factory :nick do
    channel
    irc_user
    timestamp '2016-04-01 12:35:01 +0900'
    nick 'rgrb'
    message 'rgrb2'
  end
end
