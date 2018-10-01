require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Sorcery::TestHelpers::Rails::Integration
  include Sorcery::TestHelpers::Rails::Controller

  setup do
    @setting = create(:setting)

    User.delete_all
    @user = create(:user)
  end

  teardown do
    User.delete_all
  end

  test 'index: ログインしている場合、表示される' do
    login_user(@user)

    get(:index)

    assert_response(:success)
  end

  test 'index: ログインしていない場合、ログインページにリダイレクトされる' do
    logout_user

    get(:index)

    assert_redirected_to(:login, 'ログインページにリダイレクトされる')
    refute_nil(flash[:warning], 'warningのflashが表示される')
  end

  test 'show: ログインしていない場合、ログインページにリダイレクトされる' do
    logout_user

    get(:show, params: {id: @user.friendly_id})

    assert_redirected_to(:login, 'ログインページにリダイレクトされる')
    refute_nil(flash[:warning], 'warningのflashが表示される')
  end

  test 'show: ログインしている場合、表示される' do
    login_user(@user)

    get(:show, params: {id: @user.friendly_id})

    assert_response(:success)
  end

  test 'edit: ログインしていない場合、ログインページにリダイレクトされる' do
    logout_user

    get(:edit, params: {id: @user.friendly_id})

    assert_redirected_to(:login, 'ログインページにリダイレクトされる')
    refute_nil(flash[:warning], 'warningのflashが表示される')
  end

  test 'edit: ログインしている場合、表示される' do
    login_user(@user)

    get(:edit, params: {id: @user.friendly_id})

    assert_response(:success)
  end

  test 'create: 追加に成功する' do
    login_user(@user)

    post(
      :create,
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

  test 'create: 無効な値の場合は追加に失敗する' do
    login_user(@user)

    post(
      :create,
      params: {
        user: {
          username: '',
          password: '12345678',
          password_confirmation: '1234567'
        }
      }
    )

    assert_template(:new, '新規テンプレートが描画される')
    assert_select('.alert-danger', true, 'エラーメッセージが表示される')
  end

  test 'update: 更新に成功する' do
    login_user(@user)

    process(
      :update,
      method: :patch,
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
    login_user(@user)

    process(
      :update,
      method: :patch,
      params: {
        id: @user.friendly_id,
        user: {
          username: '',
          password: '12345678',
          password_confirmation: '1234567'
        }
      }
    )

    assert_template(:edit, '編集テンプレートが描画される')
    assert_select('.alert-danger', true, 'エラーメッセージが表示される')
    assert_select('ol.breadcrumb a', @user.username, 'パンくずリスト：元の利用者名が表示される')
  end
end
