# frozen_string_literal: true

namespace :json do
  desc 'データをJSONファイルに出力する。output_dir で出力先を指定する。'
  task :dump, [:output_dir] => :environment do |_, args|
    tables = [
      'channels',
      'irc_users',
      'settings',
      'users',
      'messages',
      'conversation_messages'
    ]

    tables.each do |t|
      Rake::Task["json:dump:#{t}"].invoke(args[:output_dir])
    end
  end

  namespace :dump do
    desc 'テーブルchannelsの内容をchannels.jsonに出力する'
    task :channels, [:output_dir] => :environment do |_, args|
      in_output_dir(args) do
        save_json_of(Channel, 'channels.json')
      end
    end

    desc 'テーブルirc_usersの内容をirc_user_N.jsonに出力する'
    task :irc_users, [:output_dir] => :environment do |_, args|
      in_output_dir(args) do
        save_json_in_batch(IrcUser, 'irc_users')
      end
    end

    desc 'テーブルsettingsの内容をsettings.jsonに出力する'
    task :settings, [:output_dir] => :environment do |_, args|
      in_output_dir(args) do
        save_json_of(Setting, 'settings.json')
      end
    end

    desc 'テーブルusersの内容をusers.jsonに出力する'
    task :users, [:output_dir] => :environment do |_, args|
      in_output_dir(args) do
        save_json_of(User, 'users.json')
      end
    end

    desc 'テーブルmessagesの内容をmessages_N.jsonに出力する'
    task :messages, [:output_dir] => :environment do |_, args|
      in_output_dir(args) do
        save_json_in_batch(Message, 'messages', [:channel, :irc_user])
      end
    end

    desc 'テーブルconversation_messagesの内容をconversation_messages_N.jsonに出力する'
    task :conversation_messages, [:output_dir] => :environment do |_, args|
      in_output_dir(args) do
        save_json_in_batch(ConversationMessage,
                           'conversation_messages',
                           [:channel, :irc_user])
      end
    end

    # 出力ディレクトリの中で作業する
    # @param [Rake::TaskArguments] args タスクの引数
    #
    # 出力ディレクトリに書き込み可能かどうかのチェックの後で
    # カレントディレクトリを変更し、作業する。
    def in_output_dir(args)
      output_dir = args[:output_dir]
      check_output_dir_is_writable!(output_dir)

      chdir(output_dir, verbose: true) do
        yield
      end
    end

    # 出力先ディレクトリに書き込み可能かを調べる
    # @param [String] output_dir 出力先ディレクトリ
    # @return [true] 出力先ディレクトリに書き込み可能だった場合
    def check_output_dir_is_writable!(output_dir)
      raise ArgumentError, '出力先が指定されていません' unless output_dir
      raise Errno::ENOTDIR, output_dir unless File.directory?(output_dir)
      raise Errno::EACCES, output_dir unless File.writable?(output_dir)

      true
    end

    # モデルに対応するJSONファイルを出力する
    # @param [Class] model_class モデルのクラス
    # @param [String] filename 出力するJSONファイルの名前
    # @return [void]
    #
    # 件数が少ない場合はこちらを使う。
    def save_json_of(model_class, filename)
      hashes = model_class.hash_for_json
      save_json(hashes, filename)
    end

    # バッチ処理でJSONファイルを出力する
    # @param [Class] model_class モデルのクラス
    # @param [String] filename_prefix 出力するJSONファイルの名前の接頭辞
    #
    # 件数が多く、JSONファイルを分割したい場合はこちらを使う。
    def save_json_in_batch(model_class, filename_prefix, with = [])
      # 1ファイルに含める最大件数
      # TODO: 変更できるようにする？
      n_per_file = 10000

      n = model_class.count
      return if n < 1

      # n_per_file件までは1ファイル
      # (n_per_file + 1)件からは次のファイル
      #
      # 例:
      #  9,999 件 -> 1 ファイル
      # 10,000 件 -> 1 ファイル
      # 10,001 件 -> 2 ファイル
      # 19,999 件 -> 2 ファイル
      # 20,000 件 -> 2 ファイル
      # 20,001 件 -> 3 ファイル
      n_files = 1 + (n - 1) / n_per_file

      n_digits = 1 + Math.log10(n_files).floor
      filename_format = "#{filename_prefix}_%0#{n_digits}d.json"

      i = 1
      model_class.each_group_of_hash_for_json_in_batches(
        n_per_file, with
      ) do |hashes|
        filename = filename_format % i
        save_json(hashes, filename)

        i += 1
      end
    end

    # 与えられたオブジェクトをJSONファイルに出力する
    # @param [Object] obj 書き出すオブジェクト
    # @param [String] filename 出力するJSONファイルの名前
    # @return [void]
    # @note これは直接呼び出さないこと。
    def save_json(obj, filename)
      File.open(filename, 'w') do |f|
        f.puts(JSON.pretty_generate(obj))
      end

      puts(filename)
    end
  end
end
