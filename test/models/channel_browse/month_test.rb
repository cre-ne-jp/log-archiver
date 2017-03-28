require 'test_helper'

class ChannelBrowse::MonthTest < ActiveSupport::TestCase
  setup do
    @month = build(:channel_browse_month)
  end

  test '有効である' do
    assert(@month.valid?)
  end

  test 'channel は必須' do
    @month.channel = nil
    refute(@month.valid?)
  end

  test 'year は必須' do
    @month.year = nil
    refute(@month.valid?)
  end

  test 'year は整数' do
    @month.year = 2000.1
    refute(@month.valid?)
  end

  test 'month は必須' do
    @month.month = nil
    refute(@month.valid?)
  end

  test 'month は整数' do
    @month.month = 1.5
    refute(@month.valid?)
  end

  test 'month は 1 以上' do
    @month.month = 1
    assert(@month.valid?, '1 は有効')

    @month.month = 0
    refute(@month.valid?, '0 は無効')
  end

  test 'month は 12 以下' do
    @month.month = 12
    assert(@month.valid?, '12 は有効')

    @month.month = 13
    refute(@month.valid?, '13 は無効')
  end

  test 'params_for_url の結果が正しい' do
    params = @month.params_for_url

    assert_equal(@month.channel.identifier, params.fetch(:identifier), 'identifier')
    assert_equal(@month.year.to_s, params.fetch(:year), 'year')
    assert_equal('%02d' % @month.month, params.fetch(:month), 'month')
  end
end
