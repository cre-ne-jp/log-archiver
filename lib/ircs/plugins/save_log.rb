# vim: fileencoding=utf-8

require 'pp'

module LogArchiver
  module Plugin
    # DB にログを保存する
    class SaveLog
      include Cinch::Plugin

      set(plugin_name: 'SaveLog')

      listen_to(:join, method: :join)

      # チャンネルに誰かが JOIN したとき
      def join(m)
        if m.user.to_s != bot.nick
          # #{m.user} がJOINしたときの処理 
        end
      end
    end
  end
end
