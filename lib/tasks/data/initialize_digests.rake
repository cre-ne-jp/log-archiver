namespace :data do
  namespace :initialize_digests do
    desc 'ConversationMessage のハッシュ値を初期化する'
    task :conversation_messages => :environment do
      initialize_digests(ConversationMessage)
    end

    desc 'Message のハッシュ値を初期化する'
    task :messages => :environment do
      initialize_digests(Message)
    end

    desc '全メッセージのハッシュ値を初期化する'
    task :all => :environment do
      Rake::Task['data:initialize_digests:conversation_messages'].invoke
      Rake::Task['data:initialize_digests:messages'].invoke
    end

    private

    # ハッシュ値を初期化する
    # @param [Class] model 対象モデル
    # @return [void]
    def initialize_digests(model)
      n = model.update_all(digest: '')
      puts("#{model}: Updated #{n} records.")
    end
  end
end
