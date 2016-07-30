# vim: fileencoding=utf-8

require 'pp'

module LogArchiver
  module Plugin
    # DB にログを保存する
    class SaveLog
      include Cinch::Plugin

      set(plugin_name: 'SaveLog')

      match(:catchall, method: :catchall)

      def catchall(m)
pp m
      end
    end
  end
end
