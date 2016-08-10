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
      end

      # ログを保存するチャンネルを抽出する
      # @return[Array]
      def load_enable_channels
        Channel.where(enable: true).pluck(:downcase).map do |channel|
          "##{channel}"
        end
      end

      # ログの保存が無効化されているチャンネルを抽出する
      # @return[Array]
      def load_disable_channels
        Channel.where(enable: false).pluck(:downcase).mao do |channel|
          "##{channel}"
        end
      end

      # ログを保存する対象のチャンネルか調べる
      # @param [String] name チャンネル名
      # @return [Boolean] 保存対象だったら true
      def target_channel?(name)
        load_enable_channels.include?(name)
      end

      # データベースに書き込む
      # @param [Time] timestamp 受信日時
      # @param [String] sender 送信者の、送信時の NICK
      # @param [String] command IRC コマンド
      # @param [String] target 送信先のチャンネル
      # @param [String] body IRC コマンドの引数
      def save(timestamp, sender, command, target = nil, body = nil)
pp [timestamp, sender, command, target, body]
      end
    end
  end
end
