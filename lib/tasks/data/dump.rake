namespace :data do
  namespace :dump do
    desc 'データをJSONファイルに出力する。output_dir で出力先を指定する。'
    task :json, [:output_dir] => :environment do |t, args|
      output_dir = args[:output_dir]
      raise ArgumentError, '出力先が指定されていません' unless output_dir
      raise Errno::ENOTDIR, output_dir unless File.directory?(output_dir)
      raise Errno::EACCES, output_dir unless File.writable?(output_dir)

      # 与えられたオブジェクトをJSONファイルに出力する
      # これは直接呼び出さないこと
      save_json = lambda do |obj, filename|
        File.open(filename, 'w') do |f|
          f.puts(JSON.pretty_generate(obj))
        end

        puts(filename)
      end

      # モデルに対応するJSONファイルを出力する
      # 件数が少ない場合はこちらを使う
      save_json_of = lambda do |model_class, filename|
        hashes = model_class.hash_for_json
        save_json[hashes, filename]
      end

      # バッチ処理でJSONファイルを出力する
      # 件数が多く、JSONファイルを分割したい場合はこちらを使う
      # filename_format には '%d' を含めること
      save_json_in_batch = lambda do |model_class, filename_format|
        i = 0
        model_class.each_group_of_hash_for_json_in_batches do |hashes|
          filename = filename_format % i
          save_json[hashes, filename]

          i += 1
        end
      end

      chdir(output_dir, verbose: true) do
        save_json_of[Channel, 'channels.json']
        save_json_in_batch[IrcUser, 'irc_users_%d.json']
        save_json_in_batch[MessageDate, 'message_dates_%d.json']
        save_json_of[Setting, 'settings.json']
        save_json_of[User, 'users.json']
      end
    end
  end
end
