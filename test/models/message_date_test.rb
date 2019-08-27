require 'test_helper'

class MessageDateTest < ActiveSupport::TestCase
  setup do
    @message_date = create(:message_date)
  end

  test '有効である' do
    assert(@message_date.valid?)
  end

  test 'channel は必須' do
    @message_date.channel = nil
    refute(@message_date.valid?)
  end

  test 'date は必須' do
    @message_date.date = nil
    refute(@message_date.valid?)
  end

  def prepare_message_dates
    MessageDate.delete_all

    @message_date_20150123 = create(:message_date_20150123)
    @message_date_20160816 = create(:message_date)
    @message_date_20161231 = create(:message_date_20161231)
    @message_date_20170401 = create(:message_date_20170401)
    @message_date_20170402 = create(:message_date_20170402)
  end

  test 'years で指定したチャンネルのメッセージが存在する年の配列が返る' do
    prepare_message_dates

    channel = @message_date.channel
    years = MessageDate.years(channel)

    assert_equal([2015, 2016, 2017], years)
  end

  test 'year_month_list で指定したチャンネルのメッセージが存在する年月の配列が返る' do
    prepare_message_dates

    channel = @message_date.channel
    year_month_list = MessageDate.year_month_list(channel)

    expected = [
      [2015, 1],
      [2016, 8],
      [2016, 12],
      [2017, 4]
    ]
    assert_equal(expected, year_month_list)
  end

  test 'to_hash_for_json: 値が正しく設定される' do
    hash = @message_date.to_hash_for_json

    assert_equal(@message_date.id, hash['id'])
    assert_equal(@message_date.channel_id, hash['channel_id'])
    assert_equal(@message_date.date, Date.parse(hash['date']))
    assert_equal(@message_date.created_at, Time.parse(hash['created_at']))
    assert_equal(@message_date.updated_at, Time.parse(hash['updated_at']))
  end
end
