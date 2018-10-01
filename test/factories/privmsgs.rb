FactoryBot.define do
  factory :privmsg do
    channel
    irc_user
    timestamp '2016-04-01 12:35:03 +0900'
    nick 'rgrb'
    message 'プライベートメッセージ'

    factory :privmsg_rgrb_20140320012345 do
      timestamp '2014-03-20 01:23:45 +0900'
      message 'RGRB (irc.cre.jp)'
    end

    factory :privmsg_role_20140320023456 do
      association :irc_user, factory: :irc_user_role
      timestamp '2014-03-20 02:34:56 +0900'
      nick 'Role'
      message 'Role (irc.trpg.net)'
    end

    factory :privmsg_toybox_20140320210954 do
      association :irc_user, factory: :irc_user_toybox
      timestamp '2014-03-20 21:09:54 +0900'
      nick 'Toybox'
      message 'Toybox (irc.cre.jp)'
    end
  end
end
