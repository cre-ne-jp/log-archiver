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
      timer(10, method: :kickstart)

      # 接続時に、必要なチャンネルに JOIN する
      # @param [Cinch::Message] m
      # @return [void]
      def connect(m)
        ::Channel.logging_enabled_names_with_prefix.each do |channel|
          join(channel)
        end
      end

      # 一定間隔で実行する
      # @return [void]
      def kickstart
        joinning = bot.channels.map { |channel| channel.name.downcase }
        logging_enabled =
          ::Channel.logging_enabled_names_with_prefix(lowercase: true)

        (logging_enabled - joinning).each do |channel|
          join(channel)
        end

        (joinning - logging_enabled).each do |channel|
          part(channel)
        end
      end

      # チャンネルに JOIN する
      # @param [String] channel JOIN する対象のチャンネル名
      # @return [void]
      def join(channel)
        bot.join(channel)
        @logger.warn("#{channel} に JOIN しました")
      end

      # チャンネルから PART する
      # @param [String] channel PART する対象のチャンネル名
      # @return [void]
      def part(channel)
        bot.part(channel)
        @logger.warn("#{channel} から PART しました")
      end
    end
  end
end
