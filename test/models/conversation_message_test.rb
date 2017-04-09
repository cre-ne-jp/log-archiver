require 'test_helper'

class ConversationMessageTest < ActiveSupport::TestCase
  setup do
    @message = create(:conversation_message)
  end

  test '有効である' do
    assert(@message.valid?)
  end

  test 'channel は必須' do
    @message.channel = nil
    refute(@message.valid?)
  end

  test 'timestamp は必須' do
    @message.timestamp = nil
    refute(@message.valid?)
  end

  test 'nick は必須' do
    @message.nick = nil
    refute(@message.valid?)
  end

  test 'nick は空白のみではならない' do
    @message.nick = ' ' * 10
    refute(@message.valid?)
  end

  test 'nick は 64 文字以内' do
    @message.nick = 'a' * 64
    assert(@message.valid?, '64 文字は OK')

    @message.nick = 'a' * 65
    refute(@message.valid?, '65 文字は NG')
  end

  test 'message は 512 文字以内' do
    @message.message = 'a' * 512
    assert(@message.valid?, '512 文字は OK')

    @message.message = 'a' * 513
    refute(@message.valid?, '513 文字は NG')
  end

  test 'fragment_id が正しい' do
    assert_equal("c#{@message.id}", @message.fragment_id)
  end
end
