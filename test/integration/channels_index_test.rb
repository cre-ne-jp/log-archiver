require 'test_helper'

class ChannelsIndexTest < ActionDispatch::IntegrationTest
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
    get(channels_path)
    assert_response(:success)
  end
end
