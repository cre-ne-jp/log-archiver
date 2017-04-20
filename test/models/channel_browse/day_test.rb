require 'test_helper'

class ChannelBrowse::DayTest < ActiveSupport::TestCase
  setup do
    @channel = create(:channel)
    @day = build(:channel_browse_day)
    @now = Time.zone.local(2017, 4, 1, 12, 34, 56)
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

  test 'style は必須' do
    @day.style = nil
    refute(@day.valid?)
  end

  test 'params_for_url: 日付が正しい' do
    params = @day.params_for_url

    assert_equal(@day.date.year.to_s, params.fetch(:year), 'year')
    assert_equal('%02d' % @day.date.month, params.fetch(:month), 'month')
    assert_equal('%02d' % @day.date.day, params.fetch(:day), 'day')
  end

  test 'params_for_url: 通常のスタイルのとき :style が存在しない' do
    @day.style = :normal
    refute(@day.params_for_url.include?(:style))
  end

  test 'params_for_url: 生ログのとき :style が raw になる' do
    @day.style = :raw

    params = @day.params_for_url
    assert_equal('raw', params.fetch(:style))
  end

  test 'today で今日のログの閲覧が返る' do
    travel_to(@now) do
      browse_day = ChannelBrowse::Day.today(@channel, style: :raw)

      assert_equal(@channel, browse_day.channel, 'チャンネルが正しい')
      assert_equal(@now.to_date, browse_day.date, '日付が正しい')
      assert_equal(:raw, browse_day.style, '表示のスタイルが正しい')
    end
  end

  test 'yesterday で昨日のログの閲覧が返る' do
    travel_to(@now) do
      browse_day = ChannelBrowse::Day.yesterday(@channel, style: :raw)

      assert_equal(@channel, browse_day.channel, 'チャンネルが正しい')
      assert_equal(@now.to_date.prev_day, browse_day.date, '日付が正しい')
      assert_equal(:raw, browse_day.style, '表示のスタイルが正しい')
    end
  end

  test 'path: ログ閲覧ページのパスが正しい' do
    @day.style = :normal
    @day.date = @now.to_date

    assert_equal('/channels/irc_test/2017/04/01', @day.path)
  end

  test 'path: 生ログ閲覧ページのパスが正しい' do
    @day.style = :raw
    @day.date = @now.to_date

    assert_equal('/channels/irc_test/2017/04/01?style=raw', @day.path)
  end

  test 'url: ログ閲覧ページの URL が正しい（スキーム付き）' do
    @day.style = :normal
    @day.date = @now.to_date

    assert_equal('https://log.example.net/channels/irc_test/2017/04/01',
                 @day.url('https://log.example.net'))
  end

  test 'url: ログ閲覧ページの URL が正しい（スキームなし）' do
    @day.style = :normal
    @day.date = @now.to_date

    assert_equal('http://log.example.net/channels/irc_test/2017/04/01',
                 @day.url('log.example.net'))
  end

  test 'url: 生ログ閲覧ページの URL が正しい' do
    @day.style = :raw
    @day.date = @now.to_date

    assert_equal('https://log.example.net/channels/irc_test/2017/04/01?style=raw',
                 @day.url('https://log.example.net'))
  end
end
