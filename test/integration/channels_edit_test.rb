require 'test_helper'

class ChannelsEditTest < ActionDispatch::IntegrationTest
  setup do
    @setting = create(:setting)
    @user = create(:user)

    Channel.delete_all
    @channel = create(:channel)
  end

  teardown do
    Channel.delete_all
  end

  test 'ログインしている場合、表示される' do
    login_user(@user)

    get(edit_channel_path(@channel))

    assert_response(:success)
  end

  test 'ログインしていない場合、ログインページにリダイレクトされる' do
    logout_user

    get(edit_channel_path(@channel))

    assert_redirected_to(login_path, 'ログインページにリダイレクトされる')
    refute_nil(flash[:warning], 'warningのflashが表示される')
  end
end
