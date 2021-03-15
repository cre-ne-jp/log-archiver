require 'test_helper'

class ChannelsDaysShowTest < ActionDispatch::IntegrationTest
  setup do
    create(:setting)
    create(:user)

    MessageDate.delete_all
    Message.delete_all
    ConversationMessage.delete_all

    @channel = create(:channel)

    # NICK 1件
    create(:nick_foo_bar_20140320012354)

    create_by_id = ->id { create(id) }

    # NOTICE 1件
    create_with_factory_ids(
      :notice_toybox_20140320000000,
      # 以下、別の日
      :notice_toybox_20140321000000,
      :notice
    )

    # PRIVMSG 3件
    create_with_factory_ids(
      :privmsg_rgrb_20140320012345,
      :privmsg_role_20140320023456,
      :privmsg_toybox_20140320210954,
      # 以下、別の日
      :privmsg
    )

    # MessageDates
    create_with_factory_ids(
      :message_date_20140320,
      :message_date_20140321,
    )

    date = Date.new(2014, 3, 20)
    @browse = ChannelBrowse::Day.new(channel: @channel,
                                     date: date,
                                     style: :normal)
  end

  teardown do
    MessageDate.delete_all
    Message.delete_all
    ConversationMessage.delete_all
  end

  test 'メッセージの一覧が正しく表示される' do
    get(@browse.path)
    assert_response(:success)

    assert_select('h1',
                  '#irc_test 2014-03-20',
                  'チャンネル名と日付の見出しが存在する')

    assert_select('tr.message-type-nick', 1)
    assert_select('tr.message-type-notice', 1)
    assert_select('tr.message-type-privmsg', 3)
  end

  data(
    '通常表示' => :normal,
    '生ログ' => :raw,
  )
  test '該当なしの場合に検索結果の概要が表示されない' do
    style = data

    browse = ChannelBrowse::Day.new(
      channel: @channel,
      date: Date.new(2000, 1, 1),
      style: style
    )
    get(browse.path)
    assert_response(:success)

    assert_select('.main-panel') do
      assert_select('.day-summary', 0)
    end
  end

  data(
    '通常表示' => :normal,
    '生ログ' => :raw,
  )
  test '該当なしの場合にメッセージが表示される' do
    style = data

    browse = ChannelBrowse::Day.new(
      channel: @channel,
      date: Date.new(2000, 1, 1),
      style: style
    )
    get(browse.path)
    assert_response(:success)

    assert_select('.main-panel') do
      assert_select('p', '該当するメッセージは見つかりませんでした。')
    end
  end

  data(
    '通常表示' => :normal,
    '生ログ' => :raw,
  )
  test '該当なしの場合に「次の日」ボタンが1つのみ表示される' do
    style = data

    browse = ChannelBrowse::Day.new(
      channel: @channel,
      date: Date.new(2000, 1, 1),
      style: style
    )
    get(browse.path)
    assert_response(:success)

    assert_select('.main-panel') do
      assert_select('a.btn', { text: /次の日/, count: 1 })
    end
  end
end
