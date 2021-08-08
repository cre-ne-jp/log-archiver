# frozen_string_literal: true

require 'test_helper'
require 'application_system_test_case'
require_relative 'message_list_style_test_helper'

class MessageListStyleTest < ApplicationSystemTestCase
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
  end

  test '通常表示のとき「生ログ」を押すとCookieが正しく設定される' do
    visit(@browse.path)

    reset_message_list_style_in_cookie

    within('.main-panel .nav-tabs') do
      click_link('生ログ')
    end

    cookie_value = get_message_list_style_in_cookie
    assert_equal('raw', cookie_value)
  end

  test '生ログ表示のとき「通常表示」を押すとCookieが正しく設定される' do
    visit(@browse_raw.path)

    reset_message_list_style_in_cookie

    within('.main-panel .nav-tabs') do
      click_link('通常表示')
    end

    cookie_value = get_message_list_style_in_cookie
    assert_equal('normal', cookie_value)
  end
end
