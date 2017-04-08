require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  include Sorcery::TestHelpers::Rails::Integration
  include Sorcery::TestHelpers::Rails::Controller

  setup do
    create(:setting)
    @user = create(:user)
  end

  test 'index: ログインしていない場合、ログインページにリダイレクトされる' do
    logout_user

    get :index

    assert_redirected_to(:login, 'ログインページにリダイレクトされる')
    refute_nil(flash[:warning], 'warningのflashが表示される')
  end

  test 'index: ログインしている場合、表示される' do
    login_user(@user)

    get :index

    assert_response(:success)
  end
end
