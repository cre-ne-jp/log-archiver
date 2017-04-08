require 'test_helper'

class ChannelsNewTest < ActionDispatch::IntegrationTest
  setup do
    @setting = create(:setting)
    @user = create(:user)
  end

  test 'ログインしている場合、表示される' do
    login_user(@user)

    get(new_channel_path)

    assert_response(:success)
  end

  test 'ログインしていない場合、ログインページにリダイレクトされる' do
    logout_user

    get(new_channel_path)

    assert_redirected_to(login_path, 'ログインページにリダイレクトされる')
    refute_nil(flash[:warning], 'warningのflashが表示される')
  end
end
