require 'test_helper'

class ChannelsCreateTest < ActionDispatch::IntegrationTest
  setup do
    @setting = create(:setting)
    @user = create(:user)

    Channel.delete_all
  end

  teardown do
    Channel.delete_all
  end

  test 'ログインしていない場合、ログインページにリダイレクトされる' do
    logout_user

    post(
      channels_path,
      channel: {
        name: '新しいチャンネル',
        identifier: 'new_channel',
        logging_enabled: '1'
      }
    )

    assert_redirected_to(login_path, 'ログインページにリダイレクトされる')
    refute_nil(flash[:warning], 'warningのflashが表示される')
  end

  test '追加に成功する' do
    login_user(@user)

    post(
      channels_path,
      channel: {
        name: '新しいチャンネル',
        identifier: 'new_channel',
        logging_enabled: '1'
      }
    )

    assert_redirected_to(admin_channel_path(id: 'new_channel'), 'チャンネル情報ページにリダイレクトされる')
    refute_nil(flash[:success], 'successのflashが表示される')
  end

  test '無効な値の場合は追加に失敗する' do
    login_user(@user)

    post(
      channels_path,
      channel: {
        name: '',
        identifier: '',
        logging_enabled: '1'
      }
    )

    assert_template('channels/new', '新規テンプレートが描画される')
    assert_select('.alert-danger', true, 'エラーメッセージが表示される')
  end
end
