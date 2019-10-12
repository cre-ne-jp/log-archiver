require 'test_helper'
require 'models/test_helper_for_to_hash_for_json'

class TopicTest < ActiveSupport::TestCase
  include TestHelperForToHashForJson

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
    assert_contain_valid_conversation_message_data(@topic, hash, 'Topic')
  end
end
