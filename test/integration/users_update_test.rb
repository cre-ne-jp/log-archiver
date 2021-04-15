# frozen_string_literal: true

require 'test_helper'
require 'user_login_test_helper'

class UsersUpdateTest < ActionDispatch::IntegrationTest
  setup do
    @setting = create(:setting)

    User.delete_all
    @user = create(:user)
    @path = user_path(@user)

    @login_helper = UserLoginTestHelper.new(self, @user, @path)
  end

  teardown do
    User.delete_all
  end

  test 'ログインしていない場合、ログインページにリダイレクトされる' do
    @login_helper.assert_redirected_to_login_on_logged_out do
      patch(
        @path,
        params: {
          user: {
            username: 'new_user',
            password: '12345678',
            password_confirmation: '12345678'
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
        id: @user.friendly_id,
        user: {
          username: 'new_user',
          password: '12345678',
          password_confirmation: '12345678'
        }
      }
    )

    assert_redirected_to(user_path(id: 'new_user'), '利用者ページにリダイレクトされる')
    refute_nil(flash[:success], 'successのflashが表示される')
  end

  test 'update: 無効な値の場合は更新に失敗する' do
    @login_helper.log_in

    patch(
      @path,
      params: {
        id: @user.friendly_id,
        user: {
          username: '',
          password: '12345678',
          password_confirmation: '1234567'
        }
      }
    )

    assert_template('users/edit', '編集テンプレートが描画される')
    assert_select('.alert-danger', true, 'エラーメッセージが表示される')
    assert_select('ol.breadcrumb a', @user.username, 'パンくずリスト：元の利用者名が表示される')
  end
end
