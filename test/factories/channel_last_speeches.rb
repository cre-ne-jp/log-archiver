FactoryGirl.define do
  factory :channel_last_speech do
    channel
    conversation_message

    initialize_with { ChannelLastSpeech.find_or_create_by(channel: channel) }
  end
end
