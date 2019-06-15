require 'test_helper'

# 管理画面の結合テスト
class AdminIndexTest < ActionDispatch::IntegrationTest
  setup do
    create(:setting)
    @user = create(:user)
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
    assert_select('#version', LogArchiver::VERSION)
  end

  test 'コミットIDを取得できるとき、正しい形式で表示される' do
    assert_successful_login_and_get
    assert_select('#commit-id', /\A\h{40}\z/)
  end

  test 'コミットIDを取得できないとき、正しい形式で表示される'

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
