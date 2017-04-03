require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  setup do
    create(:setting)
  end

  test "should get new" do
    get :new
    assert_response :success
  end
end
