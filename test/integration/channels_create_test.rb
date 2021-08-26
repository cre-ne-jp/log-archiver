# frozen_string_literal: true

require 'test_helper'
require 'user_login_test_helper'

class ChannelsCreateTest < ActionDispatch::IntegrationTest
  setup do
    @setting = create(:setting)
    @user = create(:user)

    @login_helper = UserLoginTestHelper.new(self, @user, channels_path)
  end

  test 'ログインしていない場合、ログインページにリダイレクトされる' do
    @login_helper.assert_redirected_to_login_on_logged_out do
      post(
        channels_path,
        params: {
          channel: {
            name: '新しいチャンネル',
            identifier: 'new_channel',
            logging_enabled: '1'
          }
        }
      )
    end
  end

  test '追加に成功する' do
    @login_helper.log_in

    post(
      channels_path,
      params: {
        channel: {
          name: '新しいチャンネル',
          identifier: 'new_channel',
          logging_enabled: '1'
        }
      }
    )

    assert_redirected_to(admin_channel_path(id: 'new_channel'), 'チャンネル情報ページにリダイレクトされる')
    refute_nil(flash[:success], 'successのflashが表示される')
  end

  test '無効な値の場合は追加に失敗する' do
    @login_helper.log_in

    post(
      channels_path,
      params: {
        channel: {
          name: '',
          identifier: '',
          logging_enabled: '1'
        }
      }
    )

    assert_template('channels/new', '新規テンプレートが描画される')
    assert_select('.alert-danger', true, 'エラーメッセージが表示される')
  end
end
