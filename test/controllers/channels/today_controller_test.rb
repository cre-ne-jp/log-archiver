require 'test_helper'

class Channels::TodayControllerTest < ActionController::TestCase
  setup do
    Channel.delete_all
    @channel = create(:channel)
  end

  teardown do
    Channel.delete_all
  end

  test '今日のページにリダイレクトされる' do
    today = Time.zone.local(2017, 5, 1)

    travel_to(today) do
      get(:show, id: @channel.id)

      browse_day = ChannelBrowse::Day.new(channel: @channel, date: today)
      assert_redirected_to(browse_day.path)
    end
  end
end
