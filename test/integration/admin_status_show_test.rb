# frozen_string_literal: true

require 'test_helper'
require 'user_login_test_helper'
require 'admin_nav_item_test_helper'

# 「現在の状態」画面の結合テスト
class AdminStatusShowTest < ActionDispatch::IntegrationTest
  # ダミーの起動時刻
  DUMMY_START_TIME = Time.new(2014, 3, 20, 12, 34, 56, '+09:00')
  # ダミーのコミットID
  DUMMY_COMMIT_ID = '0123456789abcdef0123456789abcdef01234567'

  setup do
    create(:setting)
    @user = create(:user)

    @login_helper = UserLoginTestHelper.new(self, @user, admin_status_path)

    @original_app_status = Rails.application.config.app_status
    Rails.application.config.app_status = LogArchiver::AppStatus.new(
      LogArchiver::Version,
      DUMMY_START_TIME,
      DUMMY_COMMIT_ID
    )
  end

  teardown do
    Rails.application.config.app_status = @original_app_status
  end

  test 'ログインしていない場合、ログインページにリダイレクトされる' do
    @login_helper.assert_redirected_to_login_on_logged_out
  end

  test 'ログインしている場合、表示される' do
    @login_helper.assert_successful_login_and_get
  end

  test 'バージョン番号が正しい形式で表示される' do
    @login_helper.assert_successful_login_and_get
    assert_select('#app-version', LogArchiver::Version)
  end

  test 'コミットIDを取得できるとき、正しい形式で表示される' do
    @login_helper.assert_successful_login_and_get
    assert_select('#app-commit-id', DUMMY_COMMIT_ID)
  end

  test 'コミットIDを取得できないとき、正しい形式で表示される' do
    # コミットIDなしに設定する
    Rails.application.config.app_status = LogArchiver::AppStatus.new(
      LogArchiver::Version,
      DUMMY_START_TIME,
      ''
    )

    @login_helper.assert_successful_login_and_get
    assert_select('#app-commit-id', '-')
  end

  test '稼働時間が正しい形式で表示される' do
    @login_helper.assert_successful_login_and_get
    assert_select('#app-uptime', /\A\d+:\d{2}:\d{2}:\d{2}（\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} に起動）\z/)
  end

  test '正しい管理ナビゲーション項目がハイライトされる' do
    @login_helper.assert_successful_login_and_get
    AdminNavItemTestHelper.assert_highlighted(self, :admin_nav_status)
  end
end
