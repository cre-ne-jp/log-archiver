namespace :data do
  namespace :message_fragments do
    desc 'ConversationMessage にフラグメント識別子を追加する'
    task :add_conversation_messages => :environment do
      n = 0
      messages = ConversationMessage.
        all.
        each { |msg|
          n += 1 if msg.fragment.empty?
          msg.save!
        }

      puts("Update #{n} records.")
    end

    desc 'Message にフラグメント識別子を追加する'
    task :add_messages => :environment do
      n = 0
      messages = Message.
        all.
        each { |msg|
          n += 1 if msg.fragment.empty?
          msg.save!
        }

      puts("Update #{n} records.")
    end
  end
end
