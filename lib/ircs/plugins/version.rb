# vim: fileencoding=utf-8

require_relative 'base'

module LogArchiver
  module Plugin
    # バージョンを返す
    class Version < Base
      include Cinch::Plugin

      set(plugin_name: 'Version')
      self.prefix = '.'

      match(/version/, method: :version)

      def initialize(*)
        super

        @version =  "IRC Log Archiver #{Application::VERSION} (#{`git show -s --format=%H`.chomp})"
      end

      def version(m)
        send_and_record(m, @version)
      end
    end
  end
end
