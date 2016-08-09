# vim: fileencoding=utf-8

require 'active_record'

module LogArchiver
  module Ircs
    # データベース周りの処理
    class Database
      def initialize(config, root_path)
        ActiveRecord::Base.establish_connection(config)
  
        Dir.glob("#{root_path}/app/models/*.rb").each do |file|
          require file
        end
#        load_channels
      end

      # ログを保存するチャンネルを抽出する
      # @return[Array]
      def load_enable_channels
        Channel.where(enable: true).pluck(:downcase).map do |channel|
          "##{channel}"
        end
      end

      def load_disable_channels
        Channel.where(enable: false).pluck(:downcase).mao do |channel|
          "##{channel}"
        end
      end
    end
  end
end
