require 'test_helper'

class ChannelForChannelsIndexTest < ActiveSupport::TestCase
  setup do
    [100, 200, 300, 400, 500].each do |id|
      create("channel_#{id}".to_sym)
    end

    [100, 200, 400].each do |id|
      create("channel_#{id}_last_speech".to_sym)
    end
  end

  test 'for_channels_index の順序が正しい' do
    expected = [100, 400, 200, 300, 500].map { |id| "channel_#{id}" }
    assert_equal(expected, Channel.for_channels_index.map(&:identifier))
  end
end
