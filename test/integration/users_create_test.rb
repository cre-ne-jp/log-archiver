# frozen_string_literal: true

require 'test_helper'
require 'user_login_test_helper'

class UsersCreateTest < ActionDispatch::IntegrationTest
  setup do
    @setting = create(:setting)

    User.delete_all
    @user = create(:user)

    @login_helper = UserLoginTestHelper.new(self, @user, users_path)
  end

  teardown do
    User.delete_all
  end

  test 'ログインしていない場合、ログインページにリダイレクトされる' do
    @login_helper.assert_redirected_to_login_on_logged_out do
      post(
        users_path,
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

  test '追加に成功する' do
    @login_helper.log_in

    post(
      users_path,
      params: {
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

  test '無効な値の場合は追加に失敗する' do
    @login_helper.log_in

    post(
      users_path,
      params: {
        user: {
          username: '',
          password: '12345678',
          password_confirmation: '1234567'
        }
      }
    )

    assert_template('users/new', '新規テンプレートが描画される')
    assert_select('.alert-danger', true, 'エラーメッセージが表示される')
  end
end
