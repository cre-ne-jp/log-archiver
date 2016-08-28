FactoryGirl.define do
  factory :channel do
    name 'irc_test'
    identifier 'irc_test'
    logging_enabled true

    initialize_with { Channel.find_or_create_by(identifier: identifier) }

    factory :channel_with_camel_case_name do
      name 'CamelCaseChannel'
      identifier 'camel_case_channel'
    end
  end
end
