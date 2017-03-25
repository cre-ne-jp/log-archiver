require 'test_helper'

class ChannelBrowse::DayTest < ActiveSupport::TestCase
  setup do
    @day = build(:channel_browse_day)
  end

  test '有効である' do
    assert(@day.valid?)
  end

  test 'channel は必須' do
    @day.channel = nil
    refute(@day.valid?)
  end

  test 'date は必須' do
    @day.date = nil
    refute(@day.valid?)
  end

  test 'params_for_url の結果が正しい' do
    params = @day.params_for_url

    assert_equal(@day.channel.identifier, params.fetch(:identifier), 'identifier')
    assert_equal(@day.date.year.to_s, params.fetch(:year), 'year')
    assert_equal('%02d' % @day.date.month, params.fetch(:month), 'month')
    assert_equal('%02d' % @day.date.day, params.fetch(:day), 'day')
  end
end
