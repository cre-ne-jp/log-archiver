require 'test_helper'

class ConversationMessageArchiverTest < ActiveSupport::TestCase
  setup do
    ArchivedConversationMessage.delete_all
    ConversationMessage.delete_all
  end

  teardown do
    ArchivedConversationMessage.delete_all
    ConversationMessage.delete_all
  end

  sub_test_case 'archive!' do
    test '発言をアーカイブする（複数発言存在時）' do
      privmsg1 = create(:privmsg_rgrb_20140320012345)
      privmsg2 = create(:privmsg_role_20140320023456)
      reason = create(:archive_reason)

      channel_last_speech1 = ChannelLastSpeech.refresh!(privmsg1.channel)
      assert_equal(privmsg2, channel_last_speech1.conversation_message)

      ConversationMessageArchiver.new.archive!({
        old_id: privmsg2.id,
        archive_reason_id: reason.id,
      })

      archived_privmsg2 = ArchivedConversationMessage.find_by(old_id: privmsg2.id)
      refute_nil(archived_privmsg2)

      keys = [
        :old_id,
        :channel_id,
        :timestamp,
        :nick,
        :message,
        :type,
        :irc_user_id,
        :digest,
      ]
      expected_attrs = privmsg2.attributes.slice(keys)
      actual_attrs = archived_privmsg2.attributes.slice(keys)
      assert_equal(expected_attrs, actual_attrs)

      assert_nil(ConversationMessage.find_by(id: privmsg2.id))

      channel_last_speech2 = ChannelLastSpeech.find_by(channel: privmsg1.channel)
      assert_equal(privmsg1, channel_last_speech2.conversation_message)
    end

    test '発言をアーカイブする（発言1つのみ）' do
      privmsg = create(:privmsg)
      reason = create(:archive_reason)

      channel_last_speech1 = ChannelLastSpeech.refresh!(privmsg.channel)
      assert_equal(privmsg, channel_last_speech1.conversation_message)

      ConversationMessageArchiver.new.archive!({
        old_id: privmsg.id,
        archive_reason_id: reason.id,
      })

      archived_privmsg = ArchivedConversationMessage.find_by(old_id: privmsg.id)
      refute_nil(archived_privmsg)

      keys = [
        :channel_id,
        :timestamp,
        :nick,
        :message,
        :type,
        :irc_user_id,
        :digest,
      ]
      expected_attrs = privmsg.attributes.slice(keys)
      actual_attrs = archived_privmsg.attributes.slice(keys)
      assert_equal(expected_attrs, actual_attrs)

      assert_nil(ConversationMessage.find_by(id: privmsg.id))

      channel_last_speech2 = ChannelLastSpeech.find_by(channel: privmsg.channel)
      assert_nil(channel_last_speech2)
    end
  end

  test 'reconstitute! はアーカイブされた発言を元に戻す' do
    privmsg1 = create(:privmsg_rgrb_20140320012345)
    privmsg2 = create(:privmsg_role_20140320023456)
    reason = create(:archive_reason)

    ConversationMessageArchiver.new.archive!({
      old_id: privmsg2.id,
      archive_reason_id: reason.id,
    })

    archived_privmsg2 = ArchivedConversationMessage.find_by(old_id: privmsg2.id)
    refute_nil(archived_privmsg2)

    channel_last_speech1 = ChannelLastSpeech.find_by(channel: privmsg1.channel)
    assert_equal(privmsg1, channel_last_speech1.conversation_message)

    ConversationMessageArchiver.new.reconstitute!(archived_privmsg2.id)

    archived_privmsg2_2 = ArchivedConversationMessage.find_by(old_id: privmsg2.id)
    assert_nil(archived_privmsg2_2)

    restored_privmsg2 = ConversationMessage.find(privmsg2.id)
    assert_equal(privmsg2, restored_privmsg2)

    channel_last_speech2 = ChannelLastSpeech.find_by(channel: privmsg1.channel)
    assert_equal(restored_privmsg2, channel_last_speech2.conversation_message)
  end
end
