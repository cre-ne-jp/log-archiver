# vim: fileencoding=utf-8

require 'cinch'
require 'json'
require_relative 'plugin_template'
require 'pp'

module LogArchiver
  module Plugin
    # DB にログを保存する
    class SaveLog < Template
      include Cinch::Plugin

      set(plugin_name: 'SaveLog')

      listen_to(:join, method: :on_join)
      listen_to(:part, method: :on_part)
      listen_to(:kick, method: :on_kick)
      listen_to(:nick, method: :on_nick)
      listen_to(:topic, method: :on_message)
      listen_to(:notice, method: :on_message)
      listen_to(:privmsg, method: :on_message)

      # チャンネルに(自分を含む)誰かが JOIN したとき
      # USER / 接続元アドレスを以下の書式でメッセージ本文として扱う
      # nick!user@address
      def on_join(m)
        synchronize(:pp) do
          pp({
            time: m.time,
            user: m.user.to_s,
            command: m.command,
            channel: m.channel.name,
            message: m.prefix
          })
        end
      end

      # チャンネルから(自分を含む)誰かが PART したとき
      def on_part(m)
        synchronize(:pp) do
          pp({
            time: m.time,
            user: m.user.to_s,
            command: m.command,
            channel: m.channel.name,
            message: m.message != m.channel.name ? m.message : nil
          })
        end
      end

      # チャンネルから(自分を含む)誰かが QUIT したとき
      def on_quit(m, channels)
        synchronize(:pp) do
          channels.each do |channel|
            pp({
              time: m.time,
              user: m.user.to_s,
              command: m.command,
              channel: channel.name,
              message: m.message
            })
          end
        end
      end

      # KICK が使われたとき
      def on_kick(m)
        synchronize(:pp) do
          pp({
            time: m.time,
            user: m.user.to_s,
            command: m.command,
            channel: m.channel.name,
            message: {target: m.params[1], message: m.message}
          })
        end
      end

      # NICK を変えたとき
      # 変更後の NICK をメッセージ本文として扱う
      def on_nick(m)
        synchronize(:pp) do
          pp({
            time: m.time,
            user: m.user.last_nick,
            command: m.command,
            channel: nil,
            message: m.user
          })
        end
      end

      # TOPIC / NOTICE / PRIVMSG を受信したとき
      def on_message(m)
        # チャンネル宛ではない(プライベの)場合は保存の対象外
        return if m.channel.nil?

        synchronize(:pp) do
          pp({
            time: m.time,
            user: m.user.to_s,
            command: m.command,
            channel: m.channel.name,
            message: m.message
          })
        end
      end
    end
  end
end

class Cinch::IRC
  # 元の on_quit を保存しておく
  alias on_quit_original on_quit

  def on_quit(msg, events)
    if save_log = @bot.plugins.find { |plugin| plugin.kind_of?(LogArchiver::Plugin::SaveLog) }
      channels = @bot.channel_list.select { |channel| channel.has_user?(msg.user) }
      save_log.on_quit(msg, channels)
    end

    on_quit_original(msg, events)
  end
end
