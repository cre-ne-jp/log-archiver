# vim: fileencoding=utf-8

require_relative 'base'
require_relative '../irc_bot_version'

module LogArchiver
  module Plugin
    # バージョンを返す
    class Version < Base
      include Cinch::Plugin

      set(plugin_name: 'Version')
      self.prefix = '.'

      match(/version/, method: :version)

      def version(m)
        send_and_record(m, Ircs::APP_NAME_VERSION_COMMIT_ID)
      end
    end
  end
end
