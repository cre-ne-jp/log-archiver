namespace :data do
  namespace :initialize_digests do
    desc 'ConversationMessage のフラグメント識別子を初期化する'
    task :conversation_messages => :environment do
      n = ConversationMessage.update_all(digest: '')
      puts("ConversationMessage: Updated #{n} records.")
    end

    desc 'Message のフラグメント識別子を初期化する'
    task :messages => :environment do
      n = Message.update_all(digest: '')
      puts("Message: Updated #{n} records.")
    end

    desc 'フラグメント識別子を初期化する'
    task :all => :environment do
      Rake::Task['data:initialize_digests:conversation_messages'].invoke
      Rake::Task['data:initialize_digests:messages'].invoke
    end
  end
end
