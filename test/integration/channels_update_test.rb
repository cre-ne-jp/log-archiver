require 'test_helper'

class ChannelsUpdateTest < ActionDispatch::IntegrationTest
  setup do
    @setting = create(:setting)
    @user = create(:user)

    Channel.delete_all
    @channel = create(:channel)
  end

  teardown do
    Channel.delete_all
  end

  test 'ログインしていない場合、ログインページにリダイレクトされる' do
    logout_user

    patch(
      channel_path(@channel),
      channel: {
        identifier: 'new_channel',
        logging_enabled: true
      }
    )

    assert_redirected_to(login_path, 'ログインページにリダイレクトされる')
    refute_nil(flash[:warning], 'warningのflashが表示される')
  end

  test '更新に成功する' do
    login_user(@user)

    patch(
      channel_path(@channel),
      channel: {
        identifier: 'new_channel',
        logging_enabled: true
      }
    )

    assert_redirected_to(admin_channel_path(id: 'new_channel'), 'チャンネル情報ページにリダイレクトされる')
    refute_nil(flash[:success], 'successのflashが表示される')
  end

  test '無効な値の場合は更新に失敗する' do
    login_user(@user)

    patch(
      channel_path(@channel),
      channel: {
        identifier: '',
        logging_enabled: true
      }
    )

    assert_template('channels/edit', '編集テンプレートが描画される')
    assert_select('.alert-danger', true, 'エラーメッセージが表示される')
  end
end
