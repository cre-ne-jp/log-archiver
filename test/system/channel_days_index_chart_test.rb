# frozen_string_literal: true

require 'test_helper'
require 'application_system_test_case'
require_relative 'message_list_style_test_helper'

class ChannelDaysIndexChartTest < ApplicationSystemTestCase
  include MessageListStyleTestHelper

  setup do
    create(:setting)
    create(:user)

    @channel = create(:channel)

    create(:privmsg_rgrb_20140320012345)
    create(:message_date_20140320)

    date = Date.new(2014, 3, 20)
    @browse = ChannelBrowse::Day.new(channel: @channel, date: date, style: :normal)
    @browse_raw = ChannelBrowse::Day.new(channel: @channel, date: date, style: :raw)

    @browse_month = ChannelBrowse::Month.new(
      channel: @channel, year: date.year, month: date.month
    )
  end

  test '月のページにおいてグラフが描画されている' do
    visit(@browse_month.path)

    sleep(0.5)

    chart_canvas = find_chart_canvas
    assert do
      chart_canvas.matches_css?('.chartjs-render-monitor')
    end
  end

  test 'グラフのバーをクリックすると日付ページに移動する（スタイル指定なし）' do
    visit(root_path)

    reset_message_list_style_in_cookie

    visit(@browse_month.path)

    sleep(0.5)

    chart_canvas = find_chart_canvas
    chart_canvas.click

    sleep(1)

    assert_equal(@browse.path, current_path)

    article = find('article')
    assert_equal('normal', article['data-message-filter-message-list-style-value'])
  end

  data(
    '標準スタイル' => 'normal',
    '生ログスタイル' => 'raw',
  )
  test 'グラフのバーをクリックすると日付ページに移動する（スタイル指定あり）' do
    style = data

    visit(root_path)

    set_message_list_style(style)

    visit(@browse_month.path)

    sleep(0.5)

    chart_canvas = find_chart_canvas
    chart_canvas.click

    sleep(1)

    assert_equal(@browse.path, current_path)

    article = find('article')
    assert_equal(style, article['data-message-filter-message-list-style-value'])
  end

  private

  def find_chart_canvas
    find('#speeches-chart')
  end
end
