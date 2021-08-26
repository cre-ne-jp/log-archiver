require 'test_helper'

class Channels::TodayControllerTest < ActionController::TestCase
  setup do
    @channel = create(:channel)
  end

  test '今日のページにリダイレクトされる' do
    today = Time.zone.local(2017, 5, 1)

    travel_to(today) do
      get(:show, params: {id: @channel.id})

      browse_day = ChannelBrowse::Day.new(channel: @channel, date: today)
      assert_redirected_to(browse_day.path)
    end
  end
end
