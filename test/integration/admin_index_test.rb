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

  test 'ログインしている場合、状態ページにリダイレクトされる' do
    login_user(@user)
    get(admin_path)
    assert_redirected_to(admin_status_path)
  end
end
