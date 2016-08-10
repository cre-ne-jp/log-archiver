# vim: fileencoding=utf-8

require 'json'
require_relative 'plugin_template'
require 'pp'

module LogArchiver
  module Plugin
    # DB にログを保存する
    class SaveLog < Template
      include Cinch::Plugin

      set(plugin_name: 'SaveLog')

      listen_to(:join, method: :join)
      listen_to(:part, method: :part)
      listen_to(:quit, method: :quit)
      listen_to(:kick, method: :kick)
      listen_to(:nick, method: :nick)
      listen_to(:topic, method: :messages)
      listen_to(:notice, method: :messages)
      listen_to(:privmsg, method: :messages)

      # チャンネルに(自分を含む)誰かが JOIN したとき
      # USER / 接続元アドレスを以下の書式でメッセージ本文として扱う
      # nick!user@address
      def join(m)
        save(m, m.channel.name, m.user.to_s, m.prefix)
#        @database.save(m.user.to_s, m.command, m.channel.name, m.prefix)
      end

      # チャンネルから(自分を含む)誰かが PART したとき
      def part(m)
        save(m, m.channel.name, m.user.to_s, m.message != m.channel.name ? m.message : nil)
#        @database.save(
#          m.user.to_s,
#          m.command,
#          m.channel.name,
#          m.message != m.channel.name ? m.message : nil
#        )
      end

      # チャンネルから(自分を含む)誰かが QUIT したとき
      def quit(m)
        save(m, nil)
#        @database.save(m.user.to_s, m.command, nil, m.message)
      end

      # KICK が使われたとき
      def kick(m)
        save(m, m.channel.name, m.user.to_s, {target: m.params[1], message: m.message}.to_json)
      end

      # NICK を変えたとき
      # 変更後の NICK をメッセージ本文として扱う
      def nick(m)
        save(m, nil, m.user.last_nick)
#        @database.save(m.user.last_nick, m.command, nil, m.message)
      end

      # TOPIC / NOTICE / PRIVMSG を受信したとき
      def messages(m)
        # チャンネル宛ではない(プライベの)場合は保存の対象外
        return if m.channel.nil?

        save(m)
#        @database.save(m.user.to_s, m.command, m.channel.name, m.message)
      end

      def save(m, channel = m.channel.name, nick = m.user.to_s, message = m.message)
        @database.save(m.time, nick, m.command, channel, message)
      end
    end
  end
end
