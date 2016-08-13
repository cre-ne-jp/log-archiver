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
end
