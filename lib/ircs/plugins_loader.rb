# vim: fileencoding=utf-8

require 'active_support/core_ext/string/inflections'

module LogArchiver
  module Ircs
    # プラグインおよびそのアダプターの require を担うクラス
    class PluginsLoader
      # プラグインのルートディレクトリ
      PLUGINS_ROOT_PATH = 'plugin'
  
      # 新しい PluginsLoader インスタンスを返す
      # @param [Array<String>] plugin_names プラグインの名前
      # @return [PluginsLoader]
      def initialize(plugin_names)
        @plugin_path = {}
        plugin_names.each do |name|
          @plugin_path[name] = "#{PLUGINS_ROOT_PATH}/#{name.underscore}"
        end
      end
  
      # プラグインの構成要素を require する
      # @return [Array] 読み込んだプラグイン構成要素のクラスの配列
      def load_each
        loaded_class = @plugin_path.map do |class_name, path|
          begin
            require_relative path
          rescue LoadError
            next nil
          end
  
          if RGRB::Plugin.const_defined?(class_name)
            RGRB::Plugin.const_get(class_name)
          else
            nil
          end
        end
  
        loaded_class.compact
      end
    end
  end
end
