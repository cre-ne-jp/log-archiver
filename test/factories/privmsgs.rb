FactoryBot.define do
  factory :privmsg do
    channel
    irc_user
    timestamp { '2016-04-01 12:35:03 +0900' }
    nick { 'rgrb' }
    message { 'プライベートメッセージ' }

    # メッセージ検索用

    factory :privmsg_rgrb_20140320012345 do
      timestamp { '2014-03-20 01:23:45 +0900' }
      message { 'RGRB (irc.cre.jp)' }
    end

    factory :privmsg_role_20140320023456 do
      association :irc_user, factory: :irc_user_role
      timestamp { '2014-03-20 02:34:56 +0900' }
      nick { 'Role' }
      message { 'Role (irc.trpg.net)' }
    end

    factory :privmsg_toybox_20140320210954 do
      association :irc_user, factory: :irc_user_toybox
      timestamp { '2014-03-20 21:09:54 +0900' }
      nick { 'Toybox' }
      message { 'Toybox (irc.cre.jp)' }
    end

    # フラグメント識別子用

    # fragment_id: #c190465ea
    factory :privmsg_keyword_sw_k do
      timestamp { '2019-10-20 01:23:45 +0900' }
      message { '.k Sword World 2.0' }
    end

    # fragment_id: #c4f6f174d
    factory :privmsg_keyword_sw_a do
      timestamp { '2019-10-20 01:23:55 +0900' }
      message { '.a Sword World 2.0' }
    end

    # fragment_id: #c110eb57c
    factory :privmsg_keyword_sw_capital do
      timestamp { '2019-10-20 01:24:05 +0900' }
      message { '.k SWORD WORLD 2.0' }
    end

    # fragment_id: #c53c2aad9
    factory :privmsg_keyword_sw_zenkaku do
      timestamp { '2019-10-20 01:24:15 +0900' }
      message { '.k　Ｓｗｏｒｄ　Ｗｏｒｌｄ　２．０' }
    end

    # 期間指定用

    factory :privmsg_rgrb_channel_100_20200320012345 do
      association :channel, factory: :channel_100
      timestamp { '2020-03-20 01:23:45 +0900' }
      message { 'RGRB (irc.cre.jp)' }
    end

    factory :privmsg_role_channel_200_20200320023456 do
      association :channel, factory: :channel_200
      association :irc_user, factory: :irc_user_role
      timestamp { '2020-03-20 02:34:56 +0900' }
      nick { 'Role' }
      message { 'Role (irc.trpg.net)' }
    end

    factory :privmsg_toybox_channel_300_20200320210954 do
      association :channel, factory: :channel_300
      association :irc_user, factory: :irc_user_toybox
      timestamp { '2020-03-20 21:09:54 +0900' }
      nick { 'Toybox' }
      message { 'Toybox (irc.cre.jp)' }
    end
  end
end
