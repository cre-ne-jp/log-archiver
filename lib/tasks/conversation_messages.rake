namespace :data do
  namespace :conversation_messages do
    desc 'すべての PRIVMSGs, NOTICEs, TOPICs を conversation messages に変換する'
    task :convert => :environment do
      messages = Message.
        where(type: %w{Privmsg Notice Topic}).
        map { |msg|
          ConversationMessage.new(
            channel: msg.channel,
            irc_user: msg.irc_user,
            command: msg.type.downcase,
            timestamp: msg.timestamp,
            nick: msg.nick,
            message: msg.message
          )
        }
      ConversationMessage.import(messages)

      puts("#{ConversationMessage.count} records.")
    end

    desc 'すべての conversation messages を削除する'
    task :delete_all => :environment do
      count = ConversationMessage.delete_all
      puts("Deleted #{count} records.")
    end
  end
end
