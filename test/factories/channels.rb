FactoryBot.define do
  factory :channel do
    name { 'irc_test' }
    identifier { 'irc_test' }
    logging_enabled { true }

    initialize_with { Channel.find_or_create_by(identifier: identifier) }

    factory :channel_with_camel_case_name do
      name { 'CamelCaseChannel' }
      identifier { 'camel_case_channel' }
    end

    factory :channel_100 do
      name { 'チャンネル100' }
      identifier { 'channel_100' }
    end

    factory :channel_200 do
      name { 'チャンネル200' }
      identifier { 'channel_200' }
    end

    factory :channel_300 do
      name { 'チャンネル300' }
      identifier { 'channel_300' }
    end

    factory :channel_400 do
      name { 'チャンネル400' }
      identifier { 'channel_400' }
    end

    factory :channel_500 do
      name { 'チャンネル500' }
      identifier { 'channel_500' }
    end
  end
end
