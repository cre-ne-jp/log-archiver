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

    assert_equal(@month.year.to_s, params.fetch(:year), 'year')
    assert_equal('%02d' % @month.month, params.fetch(:month), 'month')
  end

  test 'path: 月のページのパスが正しい' do
    assert_equal('/channels/irc_test/2017/02', @month.path)
  end

  test 'path: フラグメント識別子を指定することができる' do
    assert_equal('/channels/irc_test/2017/02#12345',
                 @month.path(anchor: '12345'))
  end

  test 'url: 月のページの URL が正しい（スキーム付き）' do
    assert_equal('https://log.example.net/channels/irc_test/2017/02',
                 @month.url('https://log.example.net'))
  end

  test 'url: 月のページの URL が正しい（スキームなし）' do
    assert_equal('http://log.example.net/channels/irc_test/2017/02',
                 @month.url('log.example.net'))
  end

  test 'url: フラグメント識別子を指定することができる' do
    assert_equal('https://log.example.net/channels/irc_test/2017/02#12345',
                 @month.url('https://log.example.net', anchor: '12345'))
  end

  def prepare_message_dates
    MessageDate.delete_all

    @message_date_20160816 = create(:message_date)
    @message_date_20161231 = create(:message_date_20161231)
    @message_date_20170401 = create(:message_date_20170401)
  end

  test 'prev_month: メッセージが記録されている前の月の閲覧を返す' do
    prepare_message_dates

    date = @message_date_20161231.date
    @month.year = date.year
    @month.month = date.month

    prev_date = @message_date_20160816.date
    prev_month = @month.prev_month

    assert_equal(@month.channel, prev_month.channel, 'チャンネルが正しい')
    assert_equal(prev_date.year, prev_month.year, '年が正しい')
    assert_equal(prev_date.month, prev_month.month, '月が正しい')
    assert(prev_month.valid?)
  end

  test 'prev_month: メッセージが記録されている最初の月だった場合nilを返す' do
    prepare_message_dates

    date = @message_date_20160816.date
    @month.year = date.year
    @month.month = date.month

    assert_nil(@month.prev_month)
  end

  test 'next_month: メッセージが記録されている次の月の閲覧を返す' do
    prepare_message_dates

    date = @message_date_20161231.date
    @month.year = date.year
    @month.month = date.month

    next_date = @message_date_20170401.date
    next_month = @month.next_month

    assert_equal(@month.channel, next_month.channel, 'チャンネルが正しい')
    assert_equal(next_date.year, next_month.year, '年が正しい')
    assert_equal(next_date.month, next_month.month, '月が正しい')
    assert(next_month.valid?)
  end

  test 'next_month: メッセージが記録されている最後の月だった場合nilを返す' do
    prepare_message_dates

    date = @message_date_20170401.date
    @month.year = date.year
    @month.month = date.month

    assert_nil(@month.next_month)
  end
end
