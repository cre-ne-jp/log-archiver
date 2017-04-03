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
end
