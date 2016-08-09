# vim: fileencoding=utf-8

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

      # チャンネルに(自分を含む)誰かが JOIN したとき
      def join(m)
        @database.save(m.user.to_s, 'JOIN', m.channel.name)
      end

      # チャンネルから(自分を含む)誰かが PART したとき
      def part(m)
        @database.save(
          m.user.to_s,
          m.command,
          m.channel.name,
          m.message != m.channel.name ? m.message : nil
        )
      end

      # チャンネルから(自分を含む)誰かが QUIT したとき
      def quit(m)
        @database.save(m.user.to_s, m.command, nil, m.message)
      end
    end
  end
end
