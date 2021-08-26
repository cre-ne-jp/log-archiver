require 'test_helper'

class ChannelsIndexTest < ActionDispatch::IntegrationTest
  setup do
    @setting = create(:setting)
    @user = create(:user)
    @channel = create(:channel)
  end

  test '表示される' do
    get(channels_path)
    assert_response(:success)
  end
end
