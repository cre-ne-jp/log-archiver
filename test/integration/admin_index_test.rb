require 'test_helper'

class AdminIndexTest < ActionDispatch::IntegrationTest
  setup do
    create(:setting)
    @user = create(:user)
  end

  test 'index: ログインしていない場合、ログインページにリダイレクトされる' do
    logout_user

    get(admin_path)

    assert_redirected_to(:login, 'ログインページにリダイレクトされる')
    refute_nil(flash[:warning], 'warningのflashが表示される')
  end

  test 'index: ログインしている場合、表示される' do
    login_user(@user)

    get(admin_path)

    assert_response(:success)
  end
end
