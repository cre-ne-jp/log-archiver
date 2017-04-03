require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  include Sorcery::TestHelpers::Rails::Integration
  include Sorcery::TestHelpers::Rails::Controller

  setup do
    @setting = create(:setting)
    @user = create(:user)
  end

  test 'edit: ログインしていない場合、ログインページにリダイレクトされる' do
    logout_user

    get(:edit)

    assert_redirected_to(:login, 'ログインページにリダイレクトされる')
    refute_nil(flash[:warning], 'warningのflashが表示される')
  end

  test 'edit: ログインしている場合、表示される' do
    login_user(@user)

    get(:edit)

    assert_response(:success)
  end

  test 'update: 更新に成功する' do
    login_user(@user)

    patch(
      :update,
      setting: {
        site_title: '新しいサイト名',
        text_on_homepage: '新しい文章'
      }
    )

    assert_redirected_to(:admin, '管理ページにリダイレクトされる')
    refute_nil(flash[:success], 'successのflashが表示される')
  end

  test 'update: 無効な値の場合は更新に失敗する' do
    login_user(@user)

    patch(
      :update,
      setting: {
        # 無効なサイト名
        site_title: '',
        text_on_homepage: '新しい文章'
      }
    )

    assert_template(:edit, '編集テンプレートが描画される')
    assert_select('.alert-danger', true, 'エラーメッセージが表示される')
  end
end
