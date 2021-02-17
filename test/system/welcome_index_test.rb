require 'test_helper'
require 'application_system_test_case'
require_relative 'flatpickr_test_helper'

class WelcomeIndexTest < ApplicationSystemTestCase
  include FlatpickrTestHelper

  setup do
    create(:setting)
  end

  test 'Flatpickr for channel_browse_date should work' do
    visit(root_url)

    within('.main-panel') do
      click_link('チャンネル')
    end
    assert_selector('#browse.active')

    within('#channel_browse_date_type') do
      choose('指定')
    end

    assert_date_picker_work('channel_browse_date')
  end

  data(
    'since' => 'message_search_since',
    'until' => 'message_search_until',
  )
  test 'Flatpickr for message_search should work' do
    target_id = data

    visit(root_url)

    click_link('検索')
    assert_selector('#search.active')

    assert_date_picker_work(target_id)
  end

  test 'minDate of #message_search_until should be set' do
    visit(root_url)

    click_link('検索')
    assert_selector('#search.active')

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

  test 'maxDate of #message_search_since should be set' do
    visit(root_url)

    click_link('検索')
    assert_selector('#search.active')

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

  data(
    'since' => 'message_period_since',
    'until' => 'message_period_until',
  )
  test 'Flatpickr for message_period should work' do
    target_id = data

    visit(root_url)

    click_link('期間')
    assert_selector('#period.active')

    assert_datetime_picker_work(target_id)
  end

  test 'minDate of #message_period_until should be set' do
    visit(root_url)

    click_link('期間')
    assert_selector('#period.active')

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

  test 'maxDate of #message_period_since should be set' do
    visit(root_url)

    click_link('期間')
    assert_selector('#period.active')

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

  test 'maxDate of #message_search_since should be set after error' do
    visit(root_url)

    click_link('検索')
    assert_selector('#search.active')

    click_button('検索')

    # キーワードやニックネームを入力せずに検索するので、
    # エラーが発生するはず
    assert_selector('#error-explanation')

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

  test 'maxDate of #message_period_since should be set after error' do
    visit(root_url)

    click_link('期間')
    assert_selector('#period.active')

    click_button('検索')

    # キーワードやニックネームを入力せずに検索するので、
    # エラーが発生するはず
    assert_selector('#error-explanation')

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
