require 'test_helper'

class ChannelsShowTest < ActionDispatch::IntegrationTest
  setup do
    @setting = create(:setting)
    @user = create(:user)

    Channel.delete_all
    @channel = create(:channel)
  end

  teardown do
    Channel.delete_all
  end

  test '表示される' do
    get(channel_path(@channel))
    assert_response(:success)
  end
end
