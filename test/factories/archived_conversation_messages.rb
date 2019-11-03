FactoryBot.define do
  factory :archived_conversation_message do
    old_id { 1 }
    channel
    irc_user
    type { 'Privmsg' }
    timestamp { "2016-11-29 00:42:49" }
    nick { 'rgrb' }
    message { 'Hello world' }
    archive_reason
  end
end
