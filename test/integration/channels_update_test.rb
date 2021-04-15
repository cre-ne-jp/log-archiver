# frozen_string_literal: true

require 'test_helper'
require 'user_login_test_helper'

class ChannelsUpdateTest < ActionDispatch::IntegrationTest
  setup do
    @setting = create(:setting)
    @user = create(:user)

    Channel.delete_all
    @channel = create(:channel)
    @path = channel_path(@channel)

    @login_helper = UserLoginTestHelper.new(self, @user, @path)
  end

  teardown do
    Channel.delete_all
  end

  test 'ログインしていない場合、ログインページにリダイレクトされる' do
    @login_helper.assert_redirected_to_login_on_logged_out do
      patch(
        @path,
        params: {
          channel: {
            identifier: 'new_channel',
            logging_enabled: true
          }
        }
      )
    end
  end

  test '更新に成功する' do
    @login_helper.log_in

    patch(
      @path,
      params: {
        channel: {
          identifier: 'new_channel',
          logging_enabled: true
        }
      }
    )

    assert_redirected_to(admin_channel_path(id: 'new_channel'), 'チャンネル情報ページにリダイレクトされる')
    refute_nil(flash[:success], 'successのflashが表示される')
  end

  test '無効な値の場合は更新に失敗する' do
    @login_helper.log_in

    patch(
      @path,
      params: {
        channel: {
          identifier: '',
          logging_enabled: true
        }
      }
    )

    assert_template('channels/edit', '編集テンプレートが描画される')
    assert_select('.alert-danger', true, 'エラーメッセージが表示される')
  end
end
