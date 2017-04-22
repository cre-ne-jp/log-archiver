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

    assert_equal(@year.year.to_s, params.fetch(:year), 'year')
  end

  test 'path: 年のページのパスが正しい' do
    assert_equal('/channels/irc_test/2017', @year.path)
  end

  test 'path: フラグメント識別子を指定することができる' do
    assert_equal('/channels/irc_test/2017#12345',
                 @year.path(anchor: '12345'))
  end

  test 'url: 年のページの URL が正しい（スキーム付き）' do
    assert_equal('https://log.example.net/channels/irc_test/2017',
                 @year.url('https://log.example.net'))
  end

  test 'url: 年のページの URL が正しい（スキームなし）' do
    assert_equal('http://log.example.net/channels/irc_test/2017',
                 @year.url('log.example.net'))
  end

  test 'url: フラグメント識別子を指定することができる' do
    assert_equal('https://log.example.net/channels/irc_test/2017#12345',
                 @year.url('https://log.example.net', anchor: '12345'))
  end
end
