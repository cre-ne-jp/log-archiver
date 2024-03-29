# frozen_string_literal: true

require 'test_helper'
require 'user_login_test_helper'
require 'admin_nav_item_test_helper'

class ChannelsEditTest < ActionDispatch::IntegrationTest
  setup do
    @setting = create(:setting)
    @user = create(:user)

    @channel = create(:channel)
    @path = edit_channel_path(@channel)

    @login_helper = UserLoginTestHelper.new(self, @user, @path)
  end

  test 'ログインしている場合、表示される' do
    @login_helper.assert_successful_login_and_get
  end

  test 'ログインしていない場合、ログインページにリダイレクトされる' do
    @login_helper.assert_redirected_to_login_on_logged_out
  end

  test '正しい管理メニュー項目がハイライトされる' do
    @login_helper.assert_successful_login_and_get
    AdminNavItemTestHelper.assert_highlighted(self, :admin_nav_channels)
  end
end
