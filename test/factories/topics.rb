FactoryGirl.define do
  factory :topic do
    channel
    irc_user
    timestamp '2016-04-01 12:35:02'
    nick 'rgrb'
    message 'IRC テスト用チャンネル'
  end
end
