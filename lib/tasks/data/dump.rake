namespace :data do
  namespace :dump do
    desc 'データをJSONファイルに出力する。output_dir で出力先を指定する。'
    task :json, [:output_dir] => :environment do |_, args|
      output_dir = args[:output_dir]
      check_output_dir_is_writable!(output_dir)

      chdir(output_dir, verbose: true) do
        save_json_of(Channel, 'channels.json')
        save_json_in_batch(IrcUser, 'irc_users_%d.json')
        save_json_in_batch(MessageDate, 'message_dates_%d.json')
        save_json_of(Setting, 'settings.json')
        save_json_of(User, 'users.json')
        save_json_of(ChannelLastSpeech, 'channel_last_speeches.json')
        save_json_in_batch(Message, 'messages_%d.json')
        save_json_in_batch(ConversationMessage, 'conversation_messages_%d.json')
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
    # @param [String] filename 出力するJSONファイルの名前
    #
    # 件数が多く、JSONファイルを分割したい場合はこちらを使う。
    # filename_format には '%d' を含めること。
    def save_json_in_batch(model_class, filename_format)
      i = 0
      model_class.each_group_of_hash_for_json_in_batches(10000) do |hashes|
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
