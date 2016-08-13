require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  setup do
    @topic = create(:topic)
  end

  test '有効である' do
    assert(@topic.valid?)
  end
end
