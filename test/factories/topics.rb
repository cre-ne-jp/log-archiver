FactoryBot.define do
  factory :topic do
    channel
    irc_user
    timestamp '2016-04-01 12:35:02 +0900'
    nick 'rgrb'
    message 'IRC テスト用チャンネル'

    factory :topic_toybox_20140320233223 do
      association :irc_user, factory: :irc_user_toybox
      timestamp '2014-03-20 23:32:23 +0900'
      nick 'Toybox'
      message 'irc.cre.jp でIRCの実験中！'
    end

    factory :topic_toybox_20140321134507 do
      association :irc_user, factory: :irc_user_toybox
      timestamp '2014-03-21 13:45:07 +0900'
      nick 'Toybox'
      message 'irc.cre.jp でのIRCの実験が完了しました'
    end
  end
end
