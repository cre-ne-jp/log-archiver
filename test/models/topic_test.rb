require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  setup do
    @topic = create(:topic)
  end

  test '有効である' do
    assert(@topic.valid?)
  end

  test 'Tiarra のログ形式が正しい' do
    assert_equal('12:35:02 Topic of channel #irc_test by rgrb: IRC テスト用チャンネル',
                 @topic.to_tiarra_format)
  end

  test 'to_hash_for_json: 値が正しく設定される' do
    hash = @topic.to_hash_for_json

    assert_equal(@topic.id, hash['id'])
    assert_equal(@topic.channel_id, hash['channel_id'])
    assert_equal(@topic.timestamp, Time.parse(hash['timestamp']))
    assert_equal(@topic.nick, hash['nick'])
    assert_equal(@topic.message, hash['message'])
    assert_equal(@topic.created_at, Time.parse(hash['created_at']))
    assert_equal(@topic.updated_at, Time.parse(hash['updated_at']))
    assert_equal('Topic', hash['type'])
    assert_equal(@topic.irc_user_id, hash['irc_user_id'])
  end
end
