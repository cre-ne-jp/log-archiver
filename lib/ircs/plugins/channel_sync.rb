# vim: fileencoding=utf-8

require_relative 'plugin_template'

module LogArchiver
  module Plugin
    # DB からチャンネル情報を読み出し、設定と実際の接続状態を比較する
    # 必要なチャンネルに JOIN する
    class ChannelSync < Template
      include Cinch::Plugin

      set(plugin_name: 'ChannelSync')

      listen_to(:connect, method: :connect)
      timer(60, method: :kickstart)

      # 接続時に、必要なチャンネルに JOIN する
      # @param [Cinch::Message] m
      # @return [void]
      def connect(m)
        @database.load_enable_channels.each do |channel|
          join(channel)
        end
      end

      # 一定間隔で実行する
      # @return [void]
      def kickstart
        irc_entry = bot.channels.map do |channel|
          channel.name.downcase
        end
        db_entry = @database.load_enable_channels
        (db_entry - irc_entry).each do |channel|
          join(channel)
        end
      end

      # チャンネルに JOIN する
      # @param [String] channel JOIN する対象のチャンネル名
      # @return [void]
      def join(channel)
        bot.join(channel)
puts("#{channel}にJOINしました")
      end
    end
  end
end
