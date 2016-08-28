FactoryGirl.define do
  factory :privmsg do
    channel
    irc_user
    timestamp '2016-04-01 12:35:03'
    nick 'rgrb'
    message 'プライベートメッセージ'
  end
end
