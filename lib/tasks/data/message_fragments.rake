namespace :data do
  namespace :message_fragments do
    desc 'ConversationMessage のフラグメント識別子を初期化する'
    task :conversation_messages => :environment do
      n = 0
      messages = ConversationMessage.
        all.
        each { |msg|
          before = msg.fragment.dup
          msg.fragment = ''
          msg.save!
          if before != msg.fragment
            n += 1
            puts "#{before} -> #{msg.fragment}"
          end
        }

      puts("Update #{n}/#{ConversationMessage.count} records.")
    end

    desc 'Message のフラグメント識別子を初期化する'
    task :messages => :environment do
      n = 0
      messages = Message.
        all.
        each { |msg|
          before = msg.fragment.dup
          msg.fragment = ''
          msg.save!
          if before != msg.fragment
            n += 1
            puts "#{before} -> #{msg.fragment}"
          end
        }

      puts("Update #{n}/#{Message.count} records.")
    end
  end
end
