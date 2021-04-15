require 'test_helper'
require 'application_system_test_case'
require_relative 'flatpickr_test_helper'

class MessagesSearchTest < ApplicationSystemTestCase
  include FlatpickrTestHelper

  setup do
    create(:setting)

    ConversationMessage.delete_all
    @privmsg = create(:privmsg)
  end

  teardown do
    ConversationMessage.delete_all
  end

  test '検索結果が正しく表示される' do
    visit(messages_search_url(q: 'メッセージ'))

    assert_selector('h2', exact_text: '2016-04-01')

    # 検索結果が1件のみ
    assert_selector('.message-type-privmsg', count: 1)

    within('.message-type-privmsg') do
      assert_selector('dt', exact_text: 'rgrb')
      assert_selector('dd', exact_text: 'プライベートメッセージ')

      within('.message-channel') do
        assert(has_link?('#irc_test', exact: true, href: channel_path('irc_test')))
      end
    end
  end

  test '該当なしの場合にメッセージが表示される' do
    visit(messages_search_url(q: 'message'))

    within('.main-panel') do
      assert_text('該当するメッセージは見つかりませんでした。')
    end
  end

  data(
    'since' => 'message_search_since',
    'until' => 'message_search_until',
  )
  test 'Flatpickrが動作する' do
    target_id = data

    visit(messages_search_url(q: 'メッセージ'))

    assert_date_picker_work(target_id)
  end

  test '#message_search_untilのminDateが設定される' do
    visit(messages_search_url(q: 'メッセージ'))

    assert_selector('#message_search_since')
    assert_selector('#message_search_until')

    execute_script(javascript_with_fp('message_search_since', <<~JS))
      fp.setDate('2021-01-02', true);
    JS

    min_date = execute_script(javascript_with_fp('message_search_until', <<~JS))
      return fp.config.minDate;
    JS
    assert_equal(Time.new(2021, 1, 2, 0, 0, 0, '+09:00'), min_date)
  end

  test '#message_search_sinceのmaxDateが設定される' do
    visit(messages_search_url(q: 'メッセージ'))

    assert_selector('#message_search_since')
    assert_selector('#message_search_until')

    execute_script(javascript_with_fp('message_search_until', <<~JS))
      fp.setDate('2021-01-02', true);
    JS

    min_date = execute_script(javascript_with_fp('message_search_since', <<~JS))
      return fp.config.maxDate;
    JS
    assert_equal(Time.new(2021, 1, 2, 0, 0, 0, '+09:00'), min_date)
  end
end
