# vim: fileencoding=utf-8

require_relative 'plugin_template'

module LogArchiver
  module Plugin
    # バージョンを返す
    class Version < Template
      include Cinch::Plugin

      set(plugin_name: 'Version')

    end
  end
end
