# frozen_string_literal: true

require 'test_helper'
require 'application_system_test_case'

class MessageFilterTest < ApplicationSystemTestCase
  ExpectedCount = Struct.new(
    :notice, :privmsg, :topic, :nick, :join, :part, :quit, :kick,
    keyword_init: true
  )

  CONTROLLER_CLASS = '.message-visibility'
  MESSAGE_LIST_CLASS = '.message-list'
  NO_MESSAGE_TEXT = '表示するメッセージがありません。'

  setup do
    create(:setting)
    create(:user)

    Message.delete_all
    ConversationMessage.delete_all

    @channel = create(:channel)

    create_speeches
    create_nicks
    create_join_part_messages

    date = Date.new(2014, 3, 20)
    @browse = ChannelBrowse::Day.new(channel: @channel,
                                     date: date,
                                     style: :normal)
    @messages_period_path = messages_period_path(
      channels: 'irc_test',
      since: '2014-03-20 00:00:00',
      until: '2014-03-21 00:00:00'
    )
  end

  teardown do
    Message.delete_all
    ConversationMessage.delete_all
  end

  test '日付ページでメッセージの表示・非表示を切り替えられる' do
    test_message_filter(@browse.path)
  end

  test '日付ページでメッセージ一覧が縞々になっている' do
    test_messages_striped(@browse.path)
  end

  test '期間指定検索ページでメッセージ一覧が縞々になっている' do
    visit(@messages_period_path)
  end

  private

  # メッセージの表示・非表示処理をテストする
  # @param [String] path 訪問するパス
  # @return [void]
  def test_message_filter(path)
    visit(path)

    # すべてチェックする
    within(CONTROLLER_CLASS) do
      check('発言')
      check('ニックネーム変更')
      check('参加・退出')
    end

    assert_message_count(ExpectedCount.new(
      notice: 1,
      privmsg: 3,
      topic: 1,
      nick: 1,
      join: 1,
      part: 1,
      quit: 1,
      kick: 1,
    ))

    within('.main-panel') do
      assert_no_text(NO_MESSAGE_TEXT)
    end

    # 「発言」のみチェックを外す
    within(CONTROLLER_CLASS) do
      uncheck('発言')
      check('ニックネーム変更')
      check('参加・退出')
    end

    assert_message_count(ExpectedCount.new(
      nick: 1,
      join: 1,
      part: 1,
      quit: 1,
      kick: 1,
    ))

    # 「ニックネーム変更」のみチェックを外す
    within(CONTROLLER_CLASS) do
      check('発言')
      uncheck('ニックネーム変更')
      check('参加・退出')
    end

    assert_message_count(ExpectedCount.new(
      notice: 1,
      privmsg: 3,
      topic: 1,
      join: 1,
      part: 1,
      quit: 1,
      kick: 1,
    ))

    # 「参加・退出」のみチェックを外す
    within(CONTROLLER_CLASS) do
      check('発言')
      check('ニックネーム変更')
      uncheck('参加・退出')
    end

    assert_message_count(ExpectedCount.new(
      notice: 1,
      privmsg: 3,
      topic: 1,
      nick: 1,
    ))

    # すべてのチェックを外す
    within(CONTROLLER_CLASS) do
      uncheck('発言')
      uncheck('ニックネーム変更')
      uncheck('参加・退出')
    end

    within('.main-panel') do
      assert_no_selector(MESSAGE_LIST_CLASS)
      assert_text(NO_MESSAGE_TEXT)
    end
  end

  # 表示されているメッセージの数が正しいことを表明する
  # @param [ExpectedCount] expected_count 期待されるメッセージ数
  # @return [void]
  def assert_message_count(expected_count)
    within(MESSAGE_LIST_CLASS) do
      expected_count.each_pair do |category, count|
        assert_selector("tr.message-type-#{category}", count: count || 0)
      end
    end
  end

  # メッセージ一覧が縞々になっていることをテストする
  # @param [String] path 訪問するパス
  # @return [void]
  def test_messages_striped(path)
    visit(path)

    within(CONTROLLER_CLASS) do
      check('発言')
      check('ニックネーム変更')
      check('参加・退出')
    end

    assert_messages_striped

    within(CONTROLLER_CLASS) do
      uncheck('発言')
      check('ニックネーム変更')
      check('参加・退出')
    end

    assert_messages_striped

    within(CONTROLLER_CLASS) do
      check('発言')
      uncheck('ニックネーム変更')
      check('参加・退出')
    end

    assert_messages_striped

    within(CONTROLLER_CLASS) do
      check('発言')
      check('ニックネーム変更')
      uncheck('参加・退出')
    end

    assert_messages_striped
  end

  # メッセージ一覧が縞々になっていることを表明する
  def assert_messages_striped
    all("#{MESSAGE_LIST_CLASS} tbody tr").each.with_index(1) do |tr, i|
      expected_class = i.even? ? '.even' : '.odd'
      assert("#{i}行 => #{expected_class}") do
        tr.matches_css?(expected_class)
      end
    end
  end

  # ファクトリーからオブジェクトを作成する
  # @param [Array<Symbol>] ids ファクトリーIDの配列
  # @return [Array<Object>] 作成されたオブジェクトの配列
  def create_with_factory_ids(*ids)
    ids.map { |id| create(id) }
  end

  # 発言のメッセージを作る
  #
  # NOTICE 1件、PRIVMSG 3件、TOPIC 1件。
  def create_speeches
    create_with_factory_ids(
      :notice_toybox_20140320000000,

      :privmsg_rgrb_20140320012345,
      :privmsg_role_20140320023456,
      :privmsg_toybox_20140320210954,

      :topic_toybox_20140320233223,
    )
  end

  # ニックネーム変更のメッセージを作る
  def create_nicks
    create_with_factory_ids(:nick_foo_bar_20140320012354)
  end

  # 参加・退出のメッセージを作る
  #
  # JOIN、PART、QUIT、KICK各1件。
  def create_join_part_messages
    create_with_factory_ids(
      :join_role_20140320023455,
      :part_role_20140320023601,
      :quit_rgrb_20140320112233,
      :kick_role_bar_20140320123500,
    )
  end
end
