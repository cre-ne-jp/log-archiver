require 'test_helper'

class ChannelBrowse::YearTest < ActiveSupport::TestCase
  setup do
    create(:channel)
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

  def prepare_message_dates
    @message_date_20150123 = create(:message_date_20150123)
    @message_date_20161231 = create(:message_date_20161231)
    @message_date_20170401 = create(:message_date_20170401)
  end

  test 'prev_year: メッセージが記録されている前の年の閲覧を返す' do
    prepare_message_dates

    date = @message_date_20161231.date
    @year.year = date.year

    prev_date = @message_date_20150123.date

    prev_year = @year.prev_year
    refute_nil(prev_year)

    assert_equal(@year.channel, prev_year.channel, 'チャンネルが正しい')
    assert_equal(prev_date.year, prev_year.year, '年が正しい')
    assert(prev_year.valid?)
  end

  test 'prev_year: メッセージが記録されている最初の年だった場合nilを返す' do
    prepare_message_dates

    date = @message_date_20150123.date
    @year.year = date.year

    assert_nil(@year.prev_year)
  end

  test 'next_year: メッセージが記録されている次の年の閲覧を返す' do
    prepare_message_dates

    date = @message_date_20161231.date
    @year.year = date.year

    next_date = @message_date_20170401.date

    next_year = @year.next_year
    refute_nil(next_year)

    assert_equal(@year.channel, next_year.channel, 'チャンネルが正しい')
    assert_equal(next_date.year, next_year.year, '年が正しい')
    assert(next_year.valid?)
  end

  test 'next_year: メッセージが記録されている最後の年だった場合nilを返す' do
    prepare_message_dates

    date = @message_date_20170401.date
    @year.year = date.year

    assert_nil(@year.next_year)
  end
end
