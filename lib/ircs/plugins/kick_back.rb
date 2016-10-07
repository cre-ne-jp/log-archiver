# vim: fileencoding=utf-8

require_relative 'plugin_template'

module LogArchiver
  module Plugin
    # KICK されたとき、ログ取得対象チャンネルだった場合 JOIN しなおす
    class KickBack < Template
      include Cinch::Plugin

      set(plugin_name: 'KickBack')

      listen_to(:kick, method: :kick)

      JOIN_MESSAGE =
        "このチャンネル( %s )はログ記録対象に設定されています。" \
        "退出するとログの記録ができないため、再入室しました。" \
        "退出させる前に、ログの記録を停止させてください。\n" \
        "次の文字列を行頭から発言するとヘルプを表示します: .log-help"

      # 自分が KICK されたら自動的にそのチャンネルに戻る
      # @param [Cinch::Message] m 送信されたメッセージ
      # @return [void]
      def kick(m)
        logging_enabled =
          ::Channel.logging_enabled_names_with_prefix(lowercase: true)

        if m.params[1].downcase == bot.nick.downcase \
          && logging_enabled.include?(m.channel)
          bot.join(m.channel)
          @logger.warn("#{m.channel} から KICK されたため、JOIN し直しました")
          sleep 1
          (JOIN_MESSAGE % m.channel.to_s).each_line do |line|
            m.target.send(line, true)
            @logger.warn("<#{m.channel}>: #{line}")
          end
        end
      end
    end
  end
end
