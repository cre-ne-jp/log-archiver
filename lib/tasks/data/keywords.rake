# frozen_string_literal: true

namespace :data do
  namespace :keywords do
    desc '登録されているキーワードをすべて削除する'
    task :delete_all => :environment do
      n_relationships = PrivmsgKeywordRelationship.delete_all
      puts("#{n_relationships} 個のPRIVMSG-キーワード関連を削除しました")

      n_keywords = Keyword.delete_all
      puts("#{n_keywords} 個のキーワードを削除しました")
    end

    desc '登録されているPRIVMSGからキーワードを抽出して登録する'
    task :extract_from_privmsgs, [:command] => :environment do |_, args|
      args.with_defaults(command: '.k')
      command = args[:command]

      unless command.match?(/\A\.[a-z0-9]+/i)
        raise ArgumentError, "不正なコマンドの書式: #{command}"
      end

      extract_keyword = LogArchiver::ExtractKeyword.new(
        command_prefix: /\A#{command}[ 　]+/,
        verbose: true
      )

      privmsgs = Privmsg
        .where("message LIKE '#{command} %' OR message LIKE '#{command}　%'")
        .order(:timestamp)

      n_keywords = 0
      n_privmsgs = 0
      privmsgs.find_each do |privmsg|
        result = extract_keyword.run(privmsg)
        n_keywords += 1 if result[:keyword]
        n_privmsgs += 1 if result[:privmsg]
      end

      puts
      puts("#{n_keywords} 個のキーワードを作成しました")
      puts("#{n_privmsgs} 個のPRIVMSGとキーワードを関連付けました")
    end
  end
end
