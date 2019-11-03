require 'test_helper'

class ArchivedConversationMessageTest < ActiveSupport::TestCase
  setup do
    @message = create(:archived_conversation_message)
    @conversation_message = create(:conversation_message)
  end

  test '有効である' do
    assert(@message.valid?)
  end

  test 'old_id は必須' do
    @message.old_id = nil
    refute(@message.valid?)
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

  test 'type は必須' do
    @message.type = nil
    refute(@message.valid?)
  end

  test 'type は Privmsg, Notice のみ' do
    @message.type = 'Privmsg'
    assert(@message.valid?, 'Privmsg は OK')

    @message.type = 'Notice'
    assert(@message.valid?, 'Notice は OK')

    @message.type = 'Topic'
    refute(@message.valid?, 'Topic は NG')
  end

  test 'archive_reason は必須' do
    @message.archive_reason = nil
    refute(@message.valid?)
  end

  test 'fragment_id が正しい' do
    assert_equal("a#{@message.digest_value}", @message.fragment_id)
  end

  test 'ConversationMessage からメッセージを作成できる' do
    message = ArchivedConversationMessage.from_conversation_message(@conversation_message)
    refute(message.valid?, 'ArchiveReason を指定していなければ NG')

    message.archive_reason = create(:archive_reason)
    assert(message.valid?, 'ArchiveReason を指定すると OK')
  end
end
