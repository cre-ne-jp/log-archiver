require 'test_helper'

class PartTest < ActiveSupport::TestCase
  setup do
    @part = create(:part)
  end

  test '有効である' do
    assert(@part.valid?)
  end

  test 'Tiarra のログ形式が正しい：メッセージなし' do
    @part.message = ''
    assert_equal('12:34:58 - rgrb from #irc_test', @part.to_tiarra_format)
  end

  test 'Tiarra のログ形式が正しい：メッセージあり' do
    assert_equal('12:34:58 - rgrb from #irc_test (Bye!)',
                 @part.to_tiarra_format)
  end

  test 'to_hash_for_json: 値が正しく設定される' do
    hash = @part.to_hash_for_json

    assert_equal(@part.id, hash['id'])
    assert_equal(@part.channel_id, hash['channel_id'])
    assert_equal(@part.irc_user_id, hash['irc_user_id'])
    assert_equal('Part', hash['type'])
    assert_equal(@part.timestamp, Time.parse(hash['timestamp']))
    assert_equal(@part.nick, hash['nick'])
    assert_equal(@part.message, hash['message'])
    assert_equal(@part.target, hash['target'])
    assert_equal(@part.created_at, Time.parse(hash['created_at']))
    assert_equal(@part.updated_at, Time.parse(hash['created_at']))
  end
end
