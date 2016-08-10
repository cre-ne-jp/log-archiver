FactoryGirl.define do
  factory :channel do
    name 'irc_test'
    identifier 'irc_test'
    logging_enabled true

    initialize_with { Channel.find_or_create_by(name: name) }
  end
end
