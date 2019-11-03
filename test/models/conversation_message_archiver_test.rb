require 'test_helper'

class ConversationMessageArchiverTest < ActiveSupport::TestCase
  setup do
    @archiver = build(:conversation_message_archiver)
    @conversation_message = create(:conversation_message)
    @conversation_message.save!
    @archived_conversation_message = ArchivedConversationMessage.last
    @archive_reason = create(:archive_reason)
    @archive_reason.save!
  end

  test 'メッセージの非表示化' do
    params = {
      old_id: @conversation_message.id,
      archive_reason_id: @archive_reason.id
    }
    result = @archiver.archive!(params)
    assert(result.kind_of?(ArchivedConversationMessage))
  end

  test '非表示化されたメッセージの再表示' do
    result = @archiver.reconstitute!(@archived_conversation_message.old_id)
    assert(result.kind_of?(ConversationMessage))
  end
end
