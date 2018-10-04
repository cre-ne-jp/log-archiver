FactoryBot.define do
  factory :notice do
    channel
    irc_user
    timestamp { '2016-04-01 12:35:04 +0900' }
    nick { 'rgrb' }
    message { '通知' }

    factory :notice_toybox_20140320000000 do
      association :irc_user, factory: :irc_user_toybox
      timestamp { '2014-03-20 00:00:00 +0900' }
      nick { 'Toybox' }
      message { 'Toybox が #irc_test の皆様に 2014年03月20日 00時00分00秒 をお知らせします' }
    end

    factory :notice_toybox_20140321000000 do
      association :irc_user, factory: :irc_user_toybox
      timestamp { '2014-03-21 00:00:00 +0900' }
      nick { 'Toybox' }
      message { 'Toybox が #irc_test の皆様に 2014年03月21日 00時00分00秒 をお知らせします' }
    end
  end
end
