# frozen_string_literal: true

require 'test_helper'
require 'user_login_test_helper'
require 'admin_nav_item_test_helper'

class SettingsUpdateTest < ActionDispatch::IntegrationTest
  setup do
    @setting = create(:setting)
    @user = create(:user)

    @login_helper = UserLoginTestHelper.new(self, @user, settings_path)
  end

  test 'ログインしていない場合、ログインページにリダイレクトされる' do
    @login_helper.assert_redirected_to_login_on_logged_out do
      patch(
        settings_path,
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
      settings_path,
      params: {
        setting: {
          site_title: '新しいサイト名',
          text_on_homepage: '新しい文章'
        }
      }
    )

    assert_redirected_to(admin_path, '管理ページにリダイレクトされる')
    refute_nil(flash[:success], 'successのflashが表示される')
  end

  test '無効な値の場合は更新に失敗する' do
    @login_helper.log_in

    patch(
      settings_path,
      params: {
        setting: {
          # 無効なサイト名
          site_title: '',
          text_on_homepage: '新しい文章'
        }
      }
    )

    assert_template('settings/edit', '編集テンプレートが描画される')
    assert_select('.alert-danger', true, 'エラーメッセージが表示される')
  end
end
