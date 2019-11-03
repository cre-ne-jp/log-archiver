FactoryBot.define do
  factory :channel_last_speech do
    channel
    conversation_message

    initialize_with {
      ChannelLastSpeech.find_or_initialize_by(
        channel: channel
      ) do |new_channel_last_speech|
        new_channel_last_speech.attributes = attributes
      end
    }

    factory :channel_100_last_speech do
      association :channel, factory: :channel_100
      association :conversation_message, factory: :message_100
    end

    factory :channel_200_last_speech do
      association :channel, factory: :channel_200
      association :conversation_message, factory: :message_200
    end

    factory :channel_400_last_speech do
      association :channel, factory: :channel_400
      association :conversation_message, factory: :message_400
    end
  end
end
