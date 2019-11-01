require 'test_helper'

# 管理画面の結合テスト
class AdminIndexTest < ActionDispatch::IntegrationTest
  # ダミーの起動時刻
  DUMMY_START_TIME = Time.new(2014, 3, 20, 12, 34, 56, '+09:00')
  # ダミーのコミットID
  DUMMY_COMMIT_ID = '0123456789abcdef0123456789abcdef01234567'

  setup do
    create(:setting)
    @user = create(:user)

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
    logout_user

    get(admin_path)

    assert_redirected_to(:login, 'ログインページにリダイレクトされる')
    refute_nil(flash[:warning], 'warningのflashが表示される')
  end

  test 'ログインしている場合、表示される' do
    assert_successful_login_and_get
  end

  test 'バージョン番号が正しい形式で表示される' do
    assert_successful_login_and_get
    assert_select('#version', LogArchiver::Version)
  end

  test 'コミットIDを取得できるとき、正しい形式で表示される' do
    assert_successful_login_and_get
    assert_select('#commit-id', DUMMY_COMMIT_ID)
  end

  test 'コミットIDを取得できないとき、正しい形式で表示される' do
    # コミットIDなしに設定する
    Rails.application.config.app_status = LogArchiver::AppStatus.new(
      LogArchiver::Version,
      DUMMY_START_TIME,
      ''
    )

    assert_successful_login_and_get
    assert_select('#commit-id', '-')
  end

  test '稼働時間が正しい形式で表示される' do
    assert_successful_login_and_get
    assert_select('#uptime', /\A\d+:\d{2}:\d{2}:\d{2}（\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} に起動）\z/)
  end

  private

  def assert_successful_login_and_get
    login_user(@user)
    get(admin_path)

    assert_response(:success)
  end
end
