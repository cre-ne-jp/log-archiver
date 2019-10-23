namespace :data do
  namespace :refresh_digests do
    desc 'ConversationMessage のハッシュ値を更新する'
    task :conversation_messages => :environment do
      refresh_digests(ConversationMessage)
    end

    desc 'Message のハッシュ値を更新する'
    task :messages => :environment do
      refresh_digests(Message)
    end

    desc '全メッセージのハッシュ値を更新する'
    task :all => :environment do
      Rake::Task['data:refresh_digests:conversation_messages'].invoke
      Rake::Task['data:refresh_digests:messages'].invoke
    end

    private

    # ハッシュ値を更新する
    # @param [Class] model 対象モデル
    # @return [void]
    def refresh_digests(model, batch_size = 10000)
      n = 0
      model.find_in_batches(batch_size: batch_size) do |data|
        data.each(&:refresh_digest!)
        model.import(data, on_duplicate_key_update: [:digest])

        n += data.length
        puts("#{model}: Updated #{n} records.")
      end
    end
  end
end
