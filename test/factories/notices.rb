FactoryGirl.define do
  factory :notice do
    channel
    irc_user
    timestamp '2016-04-01 12:35:04'
    nick 'rgrb'
    message '通知'
  end
end
