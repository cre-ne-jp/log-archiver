require 'test_helper'

class ChannelsShowTest < ActionDispatch::IntegrationTest
  setup do
    @setting = create(:setting)
    @user = create(:user)
    @channel = create(:channel)
  end

  test '表示される' do
    get(channel_path(@channel))
    assert_response(:success)
  end
end
