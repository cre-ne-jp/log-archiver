namespace :data do
  namespace :refresh_digests do
    desc 'ConversationMessage のハッシュ値を更新する。batch_size で一度に処理する件数（既定値：10000）を指定する。'
    task :conversation_messages, [:batch_size] => :environment do |_, args|
      batch_size = args[:batch_size]&.to_i || 10000
      refresh_digests(ConversationMessage, batch_size)
    end

    desc 'Message のハッシュ値を更新する。batch_size で一度に処理する件数（既定値：10000）を指定する。'
    task :messages, [:batch_size] => :environment do |_, args|
      batch_size = args[:batch_size]&.to_i || 10000
      refresh_digests(Message, batch_size)
    end

    desc '全メッセージのハッシュ値を更新する。batch_size で一度に処理する件数（既定値：10000）を指定する。'
    task :all, [:batch_size] => :environment do |_, args|
      batch_size = args[:batch_size]&.to_i || 10000

      Rake::Task['data:refresh_digests:conversation_messages'].invoke(batch_size)
      Rake::Task['data:refresh_digests:messages'].invoke(batch_size)
    end

    private

    # ハッシュ値を更新する
    # @param [Class] model 対象モデル
    # @param [Integer] batch_size 一度に処理する件数
    # @return [void]
    def refresh_digests(model, batch_size = 10000)
      if batch_size < 1
        raise ArgumentError, 'batch_size には1以上を設定してください'
      end

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
