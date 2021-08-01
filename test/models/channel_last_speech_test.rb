require 'test_helper'

class ChannelLastSpeechTest < ActiveSupport::TestCase
  setup do
    @channel_last_speech = create(:channel_last_speech)
    @channel = @channel_last_speech.channel
    @message = @channel_last_speech.conversation_message
  end

  test '有効である' do
    assert(@channel_last_speech.valid?)
  end

  test 'channel は必須' do
    @channel_last_speech.channel = nil
    refute(@channel_last_speech.valid?)
  end

  test 'channel は重複してはならない' do
    channel_last_speech_2 = ChannelLastSpeech.new(
      channel: @channel,
      conversation_message: @message
    )
    refute(channel_last_speech_2.valid?)
  end

  test 'conversation_message は必須' do
    @channel_last_speech.conversation_message = nil
    refute(@channel_last_speech.valid?)
  end

  sub_test_case 'refresh!' do
    test 'チャンネル所属メッセージが複数ある場合、最新のメッセージが選ばれる' do
      @channel.conversation_messages.delete_all

      create(:privmsg)
      privmsg_a = create(:privmsg_keyword_sw_a)
      create(:privmsg_keyword_sw_k)

      channel_last_speech = ChannelLastSpeech.refresh!(@channel)

      assert_equal(privmsg_a, @channel.last_speech)
      refute_nil(channel_last_speech)
    end

    test 'チャンネル所属メッセージが存在しない場合、削除される' do
      @channel.conversation_messages.delete_all

      channel_last_speech = ChannelLastSpeech.refresh!(@channel)

      assert_nil(@channel.last_speech)
      assert_nil(channel_last_speech)
    end
  end
end
