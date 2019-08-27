namespace :data do
  namespace :dump do
    desc 'データをJSONファイルに出力する。output_dir で出力先を指定する。'
    task :json, [:output_dir] => :environment do |t, args|
      output_dir = args[:output_dir]
      raise ArgumentError, '出力先が指定されていません' unless output_dir
      raise Errno::ENOTDIR, output_dir unless File.directory?(output_dir)
      raise Errno::EACCES, output_dir unless File.writable?(output_dir)

      save_json = lambda do |filename, obj|
        File.open(filename, 'w') do |f|
          f.puts(JSON.pretty_generate(obj))
        end

        puts(filename)
      end

      chdir(output_dir, verbose: true) do
        channels = Channel.hash_for_json
        save_json['channels.json', channels]

        i = 0
        IrcUser.each_group_of_hash_for_json_in_batches do |hashes|
          filename = "irc_users_#{i}.json"
          save_json[filename, hashes]

          i += 1
        end
      end
    end
  end
end
