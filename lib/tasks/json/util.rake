require 'json'
require 'time'

# ダミーの IrcUser
DUMMY_USER = 'dummy'.freeze
DUMMY_HOST = 'irc.example.net'.freeze

namespace :json do
  namespace :util do
    desc 'JSON ファイルを結合する'
    task :concat, [:dirname] => :environment do |_, args|
      dir = args[:dirname]
      raise ArgumentError, '入力ディレクトリが指定されていません' unless dir

      result = []

      Dir.glob(File.join(dir, '/*.json')) do |filename|
        result += read_json(filename)
      end

      puts(JSON.generate(result))
    end

    desc 'JSON ファイル内のメッセージを、時系列に並べ替える'
    task :sort_by_time, [:filename] => :environment do |_, args|
      entries = read_json(args[:filename])

      i = 0
      entries.sort_by! do |entry|
        [entry['timestamp'], i += 1]
      end

      puts(JSON.generate(entries))
    end

    desc 'データの JOIN メッセージから取得した IrcUser を補完する'
    task :complement_user_host, [:filename] => :environment do |_, args|
      entries = read_json(args[:filename])

      # {
      #   'channel'.downcase => {
      #     'nick'.downcase => ['user', 'host']
      #   }
      # }
      irc_users = {}

      entries.map! do |entry|
        nick = entry['nick'].downcase
        channel = entry['channel'].downcase

        # キャッシュにチャンネル名が保存されていなければ追加
        unless irc_users.has_key?(channel)
          irc_users[channel] = {}
        end

        # entry の書き換え
        if (entry['user'].nil? || entry['user'] == DUMMY_USER) && (entry['host'].nil? || entry['host'] == DUMMY_HOST) && irc_users[channel].has_key?(nick)
          entry['user'], entry['host'] = irc_users[channel][nick]
        end

        # キャッシュの管理
        case entry['type'].upcase
        when 'JOIN'
          irc_users[channel][nick] = [entry['user'], entry['host']]
        when 'PART', 'QUIT'
          irc_users[channel].delete(nick)
        when 'NICK'
          if irc_users[channel].has_key?(nick)
            irc_users[channel][entry['message'].downcase] = irc_users[channel].delete(nick)
          end
        end

        entry.compact
      end

      puts(JSON.pretty_generate(entries))
    end

    # JSON ファイルを読み込む
    # @param [String] filename 読み込むファイル名
    # @return [Array, Hash, Nil]
    def read_json(filename)
      raise ArgumentError, '入力ファイルが指定されていません' unless filename

      begin
        entries = JSON.parse(File.read(filename, encoding: 'UTF-8'))
      rescue => e
        $stderr.puts("#{filename} #{e}")
      end
    end
  end
end
