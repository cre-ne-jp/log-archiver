namespace :data do
  namespace :initialize_fragments do
    desc 'ConversationMessage のフラグメント識別子を初期化する'
    task :conversation_messages => :environment do
      n = 0
      ConversationMessage.
        all.
        each { |msg|
        puts msg.id
          before = msg.fragment.dup
          msg.fragment = ''
          msg.save!
          if before != msg.fragment
            n += 1
            puts("ConversationMessage: #{msg.id} '#{before}' -> '#{msg.fragment}'")
          end
        }

      puts("ConversationMessage: Update #{n}/#{ConversationMessage.count} records.")
    end

    desc 'Message のフラグメント識別子を初期化する'
    task :messages => :environment do
      n = 0
      Message.
        all.
        each { |msg|
          before = msg.fragment.dup
          msg.fragment = ''
          msg.save!
          if before != msg.fragment
            n += 1
            puts("Message: #{msg.id} '#{before}' -> '#{msg.fragment}'")
          end
        }

      puts("Message: Update #{n}/#{Message.count} records.")
    end

    desc 'フラグメント識別子を初期化する'
    task :all => :environment do
      Rake::Task['data:initialize_fragments:conversation_messages'].invoke
      Rake::Task['data:initialize_fragments:messages'].invoke
    end
  end
end
