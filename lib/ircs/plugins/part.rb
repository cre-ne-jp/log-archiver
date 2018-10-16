# vim: fileencoding=utf-8

require_relative 'base'

module LogArchiver
  module Plugin
    # 退出コマンド
    class Part < Base
      include Cinch::Plugin

      set(plugin_name: 'Part')

      self.prefix = '.'
      match(/part(?:-(\w+))?\z/, method: :part)

      def initialize(*args)
        super

        config_data = config[:plugin] || {}
        @part_message =
          config_data['PartMessage'] || 'ご利用ありがとうございました'
        @locked_message =
          config_data['LockedMessage'] || 'このチャンネルで .part は使えません。'
        @logging_message = 
          config_data['LoggingMessage'] || 'このチャンネルはログ記録が有効なため、.part は使えません。'
        @part_lock = config_data['PartLock'] || []
      end

      # コマンドを発言されたらそのチャンネルから退出する
      # @param [Cinch::Message] m 送信されたメッセージ
      # @param [String] nick 指定されたニックネーム
      # @return [void]
      def part(m, nick)
        if !nick || nick.downcase == bot.nick.downcase
          @logger.warn("<#{m.channel}>: 退出コマンドが呼び出されました")

          if @part_lock.include?(m.channel)
            send_and_record(m, @locked_message)
          elsif ::Channel.logging_enabled_names_with_prefix.include?(m.channel)
            send_and_record(m, @logging_message)
          else
            Channel(m.channel).part(@part_message)
            # データベースへの記録は SaveLog プラグインが行なう
            @logger.warn("<#{m.channel}>: コマンドにより退出しました")
          end
        end
      end
    end
  end
end
