require 'test_helper'

class ChannelBrowseTest < ActiveSupport::TestCase
  setup do
    @browse = build(:channel_browse)
  end

  test '有効である' do
    assert(@browse.valid?)
  end

  test 'channel は必須' do
    @browse.channel = nil
    refute(@browse.valid?)
  end

  test 'channel がデータベースに存在しなければならない' do
    @browse.channel = 'not_found'
    refute(@browse.valid?)
  end

  test 'date_type は必須' do
    @browse.date_type = nil
    refute(@browse.valid?)
  end

  test 'date_type に today を設定できる' do
    @browse.date_type = 'today'
    assert(:today, @browse.date_type)
  end

  test 'date_type に yesterday を設定できる' do
    @browse.date_type = 'yesterday'
    assert(:yesterday, @browse.date_type)
  end

  test 'date_type に specify を設定できる' do
    @browse.date_type = 'specify'
    assert(:specify, @browse.date_type)
  end

  test 'date_type に無効な値を指定すると nil になる' do
    @browse.date_type = 'other'
    assert_nil(@browse.date_type)
  end

  test 'date_type が specify のとき date は必須' do
    @browse.date_type = 'specify'
    @browse.date = nil
    refute(@browse.valid?)
  end

  test 'attributes が正しい' do
    attributes = @browse.attributes

    assert_equal(@browse.channel, attributes.fetch('channel'), 'channel')
    assert_equal(@browse.date_type, attributes.fetch('date_type'), 'date_type')
    assert_equal(@browse.date, attributes.fetch('date'), 'date')
  end

  test 'attributes= によって属性が正しく設定される' do
    channel = create(:channel_with_camel_case_name)
    attributes = {
      'channel' => channel.identifier,
      'date_type' => 'yesterday',
      'date' => '2016-12-31'
    }

    @browse.attributes = attributes

    assert_equal(attributes['channel'], @browse.channel, 'channel')
    assert_equal(attributes['date_type'].to_sym, @browse.date_type, 'date_type')
    assert_equal(attributes['date'].to_date, @browse.date, 'date')
  end

  test 'to_channel_browse_day で ChannelBrowse::Day オブジェクトに変換することができる（今日）' do
    @browse.date_type = 'today'

    today = Time.now.to_date
    browse_day = @browse.to_channel_browse_day

    assert_equal(@browse.channel, browse_day.channel.identifier, 'channel')
    assert_equal(today, browse_day.date, 'date')
  end

  test 'to_channel_browse_day で ChannelBrowse::Day オブジェクトに変換することができる（昨日）' do
    @browse.date_type = 'yesterday'

    yesterday = Time.now.to_date.prev_day
    browse_day = @browse.to_channel_browse_day

    assert_equal(@browse.channel, browse_day.channel.identifier, 'channel')
    assert_equal(yesterday, browse_day.date, 'date')
  end

  test 'to_channel_browse_day で ChannelBrowse::Day オブジェクトに変換することができる（日付指定）' do
    browse_day = @browse.to_channel_browse_day

    assert_equal(@browse.channel, browse_day.channel.identifier, 'channel')
    assert_equal(@browse.date, browse_day.date, 'date')
  end

  test '属性が無効な場合 to_channel_browse_day で nil が返る' do
    @browse.channel = nil
    assert_nil(@browse.to_channel_browse_day)
  end
end
