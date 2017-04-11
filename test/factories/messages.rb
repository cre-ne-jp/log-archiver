FactoryGirl.define do
  factory :message do
    channel
    irc_user
    type 'Part'
    timestamp "2016-04-01 12:34:56"
    nick 'rgrb'
    message 'Bye!'
    target nil
  end
end
