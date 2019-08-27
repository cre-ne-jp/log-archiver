require 'json'
require 'time'

namespace :data do
  namespace :import do
    desc 'JSON データを読み込み、データベースに保存する'
    task :json, ['filename'] => :environment do |task, args|
      json = File.open(args['filename']) do |file|
          file.read
        end

      JSON.parse(json).each do |entry|
        begin
          timestamp = Time.parse(entry['timestamp'])

          channel = Channel.find_by(name: entry['channel'])
          raise "Table not found: #{entry['channel']}" unless channel

          MessageDate.find_or_create_by(channel: channel, date: timestamp.to_date)

          irc_user =
            if entry['user']
              IrcUser.find_or_create_by(user: entry['user'],
                                        host: entry['host'])
            else
              nil
            end

          nick = entry['nick']

          # 不正な文字を '?' に置換する
          message = entry['message']&.
            encode('UTF-16BE', invalid: :replace, replace: '?')&.
            encode('UTF-8')

          target = entry['target']

          case entry['type']
          when 'PRIVMSG'
            Privmsg.create!(timestamp: timestamp,
                            channel: channel,
                            irc_user: irc_user,
                            nick: nick,
                            message: message)
          when 'NOTICE'
            Notice.create!(timestamp: timestamp,
                           channel: channel,
                           irc_user: irc_user,
                           nick: nick,
                           message: message)
          when 'NICK'
            Nick.create!(timestamp: timestamp,
                         channel: channel,
                         irc_user: irc_user,
                         nick: nick,
                         message: message)
          when 'JOIN'
            Join.create!(timestamp: timestamp,
                         channel: channel,
                         irc_user: irc_user,
                         nick: nick)
          when 'PART'
            Part.create!(timestamp: timestamp,
                         channel: channel,
                         irc_user: irc_user,
                         nick: nick,
                         message: message)
          when 'QUIT'
            Quit.create!(timestamp: timestamp,
                         channel: channel,
                         irc_user: irc_user,
                         nick: nick,
                         message: message)
          when 'KICK'
            Kick.create!(timestamp: timestamp,
                         channel: channel,
                         irc_user: irc_user,
                         nick: nick,
                         target: target,
                         message: message)
          when 'TOPIC'
            Topic.create!(timestamp: timestamp,
                          channel: channel,
                          irc_user: irc_user,
                          nick: nick,
                          message: message)
          else
            puts("Ignored: #{timestamp}")
          end
        rescue => e
          puts("Error: #{timestamp}: #{e}")
        end
      end
    end
  end
end
