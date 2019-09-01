require 'test_helper'

class ChannelsDaysShowTest < ActionDispatch::IntegrationTest
  setup do
    create(:setting)
    create(:user)

    @channel = create(:channel)

    ConversationMessage.delete_all

    # NICK 1件
    create(:nick_foo_bar_20140320012354)

    create_by_id = ->id { create(id) }

    # NOTICE 1件
    notice_factory_ids = [
      :notice_toybox_20140320000000,
      # 以下、別の日
      :notice_toybox_20140321000000,
      :notice
    ]
    notice_factory_ids.each(&create_by_id)

    # PRIVMSG 3件
    privmsg_factory_ids = [
      :privmsg_rgrb_20140320012345,
      :privmsg_role_20140320023456,
      :privmsg_toybox_20140320210954,
      # 以下、別の日
      :privmsg
    ]
    privmsg_factory_ids.each(&create_by_id)

    date = Date.new(2014, 3, 20)
    @browse = ChannelBrowse::Day.new(channel: @channel,
                                    date: date,
                                    style: :normal)
  end

  teardown do
    ConversationMessage.delete_all
  end

  test 'メッセージの一覧が正しく表示される' do
    get(@browse.path)
    assert_response(:success)

    assert_select('h1',
                  '#irc_test 2014-03-20',
                  'チャンネル名と日付の見出しが存在する')

    assert_select('tr.message', 5)
    assert_select('tr.message-type-nick', 1)
    assert_select('tr.message-type-privmsg', 3)
    assert_select('tr.message-type-notice', 1)
  end
end
