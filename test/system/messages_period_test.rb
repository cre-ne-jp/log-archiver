require 'test_helper'
require 'application_system_test_case'
require_relative 'flatpickr_test_helper'

class MessagesPeriodTest < ApplicationSystemTestCase
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
    visit(
      messages_period_url(channels: 'irc_test',
                          since: '2016-04-01 00:00:00',
                          until: '2016-04-02 00:00:00')
    )

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

=begin
  # TODO: このテストに合うように画面を作る
  test '該当なしの場合にメッセージが表示される' do
    visit(
      messages_period_url(channels: 'irc_test',
                          since: '2000-04-01 00:00:00',
                          until: '2000-04-02 00:00:00')
    )

    within('.main-panel') do
      assert_text('該当するメッセージは見つかりませんでした。')
    end
  end
=end

  data(
    'since' => 'message_period_since',
    'until' => 'message_period_until',
  )
  test 'Flatpickrが動作する' do
    target_id = data

    visit(
      messages_period_url(channels: 'irc_test',
                          since: '2016-04-01 00:00:00',
                          until: '2022-04-01 00:00:00')
    )

    assert_datetime_picker_work(target_id)
  end

  test '#message_period_untilのminDateが設定される' do
    visit(
      messages_period_url(channels: 'irc_test',
                          since: '2016-04-01 00:00:00',
                          until: '2022-04-01 00:00:00')
    )

    assert_selector('#message_period_since')
    assert_selector('#message_period_until')

    execute_script(javascript_with_fp('message_period_since', <<~JS))
      fp.setDate('2021-01-02T03:45:21T09:00', true);
    JS

    min_date = execute_script(javascript_with_fp('message_period_until', <<~JS))
      return fp.config.minDate;
    JS
    assert_equal(Time.new(2021, 1, 2, 3, 45, 21, '+09:00'), min_date)
  end

  test '#message_period_sinceのmaxDateが設定される' do
    visit(
      messages_period_url(channels: 'irc_test',
                          since: '2016-04-01 00:00:00',
                          until: '2022-04-01 00:00:00')
    )

    assert_selector('#message_period_since')
    assert_selector('#message_period_until')

    execute_script(javascript_with_fp('message_period_until', <<~JS))
      fp.setDate('2021-01-02T03:45:21T09:00', true);
    JS

    min_date = execute_script(javascript_with_fp('message_period_since', <<~JS))
      return fp.config.maxDate;
    JS
    assert_equal(Time.new(2021, 1, 2, 3, 45, 21, '+09:00'), min_date)
  end
end
