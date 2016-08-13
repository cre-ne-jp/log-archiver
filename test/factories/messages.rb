FactoryGirl.define do
  factory :message do
    channel
    irc_user
    type ""
    timestamp "2016-04-01 12:34:56"
    nick "rgrb"
    message nil
    target nil
  end
end
