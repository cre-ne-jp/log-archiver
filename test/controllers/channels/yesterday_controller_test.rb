require 'test_helper'

class Channels::YesterdayControllerTest < ActionController::TestCase
  setup do
    @channel = create(:channel)
  end

  test '昨日のページにリダイレクトされる' do
    today = Time.zone.local(2017, 5, 1)

    travel_to(today) do
      get(:show, params: {id: @channel.id})

      browse_day = ChannelBrowse::Day.new(channel: @channel, date: Date.new(2017, 4, 30))
      assert_redirected_to(browse_day.path)
    end
  end
end
