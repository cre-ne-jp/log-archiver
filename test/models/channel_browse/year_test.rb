require 'test_helper'

class ChannelBrowse::YearTest < ActiveSupport::TestCase
  setup do
    @year = build(:channel_browse_year)
  end

  test '有効である' do
    assert(@year.valid?)
  end

  test 'channel は必須' do
    @year.channel = nil
    refute(@year.valid?)
  end

  test 'year は必須' do
    @year.year = nil
    refute(@year.valid?)
  end

  test 'year は整数' do
    @year.year = 2000.1
    refute(@year.valid?)
  end

  test 'params_for_url の結果が正しい' do
    params = @year.params_for_url

    assert_equal(@year.channel.identifier, params.fetch(:identifier), 'identifier')
    assert_equal(@year.year.to_s, params.fetch(:year), 'year')
  end
end
