require 'test_helper'
require 'application_system_test_case'

class WelcomeIndexChannelBrowseDateTest < ApplicationSystemTestCase
  setup do
    create(:setting)
  end

  test 'チャンネルタブ：日付指定欄の表示/非表示が切り替わる' do
    visit(root_url)

    test_channel_browse_date
  end

  test 'チャンネルタブ：日付指定欄の表示/非表示が切り替わる（エラー時）' do
    visit(root_url)

    click_link('期間')
    assert_selector('#period.active')

    click_button('検索')

    # チャンネルや期間を入力せずに検索するので、
    # エラーが発生するはず
    assert_selector('#error-explanation')

    test_channel_browse_date
  end

  private

  def test_channel_browse_date
    within('.main-panel') do
      click_link('チャンネル')
    end
    assert_selector('#browse.active')

    # 初期状態（「今日」）では日付指定欄が表示されない
    assert_no_channel_browse_date

    wait_time = 0.1

    within('#new_channel_browse') do
      choose('昨日')
    end
    sleep(wait_time)

    # 「昨日」では日付指定欄が表示されない
    assert_no_channel_browse_date

    within('#new_channel_browse') do
      choose('指定')
    end
    sleep(wait_time)

    # 「指定」では日付指定欄が表示される
    assert_channel_browse_date

    within('#new_channel_browse') do
      choose('今日')
    end
    sleep(wait_time)

    # 「今日」では日付指定欄が表示されない
    assert_no_channel_browse_date
  end

  def assert_channel_browse_date
    assert_selector('#channel_browse_date')

    input = find_by_id('channel_browse_date')
    assert_not_equal('false', input['required'], '必須属性が設定されている')
  end

  def assert_no_channel_browse_date
    assert_no_selector('#channel_browse_date')

    input = find_by_id('channel_browse_date', visible: :all)
    assert_equal('false', input['required'], '必須属性が設定されていない')
  end
end
