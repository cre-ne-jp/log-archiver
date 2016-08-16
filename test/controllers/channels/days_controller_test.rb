require 'test_helper'

class Channels::DaysControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
