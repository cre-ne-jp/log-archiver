FactoryBot.define do
  factory :join do
    channel
    irc_user
    timestamp { '2016-04-01 12:34:57 +0900' }
    nick { 'rgrb' }
  end
end
