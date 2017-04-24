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
end
