# frozen_string_literal: true

require 'test_helper'
require 'user_login_test_helper'

# 管理画面の結合テスト
class AdminIndexTest < ActionDispatch::IntegrationTest
  setup do
    create(:setting)
    @user = create(:user)

    @login_helper = UserLoginTestHelper.new(self, @user, admin_path)
  end

  test 'ログインしていない場合、ログインページにリダイレクトされる' do
    @login_helper.assert_redirected_to_login_on_logged_out
  end

  test 'ログインしている場合、状態ページにリダイレクトされる' do
    @login_helper.log_in
    get(admin_path)
    assert_redirected_to(admin_status_path)
  end
end
