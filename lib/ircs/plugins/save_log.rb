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
      listen_to(:topic, method: :on_topic)
      listen_to(:notice, method: :on_notice)
      listen_to(:privmsg, method: :on_privmsg)

      # チャンネルに（自分を含む）誰かが JOIN したとき
      # @param [Cinch::Message] m メッセージ
      def on_join(m)
        record_message(m) do |channel, irc_user|
          channel.joins.create!(irc_user: irc_user,
                                timestamp: m.time,
                                nick: m.user.nick)
        end
      end

      # チャンネルから(自分を含む)誰かが PART したとき
      # @param [Cinch::Message] m メッセージ
      def on_part(m)
        record_message(m) do |channel, irc_user|
          channel.parts.create!(
            irc_user: irc_user,
            timestamp: m.time,
            nick: m.user.nick,
            message: m.message != m.channel.name ? m.message : nil
          )
        end
      end

      # チャンネルから（自分を含む）誰かが QUIT したとき
      # @param [Cinch::Message] m メッセージ
      # @param [Array <Cinch::Channel>] cinch_channels 参加していたチャンネルの配列
      def on_quit(m, cinch_channels)
        record_message_to_channels(m, cinch_channels) do |channel, irc_user|
          channel.quits.create(irc_user: irc_user,
                               timestamp: m.time,
                               nick: m.user.nick,
                               message: m.message)
        end
      end

      # KICK が使われたとき
      # @param [Cinch::Message] m メッセージ
      def on_kick(m)
        record_message(m) do |channel, irc_user|
          channel.kicks.create!(irc_user: irc_user,
                                timestamp: m.time,
                                nick: m.user.nick,
                                target: m.params[1],
                                message: m.message)
        end
      end

      # NICK を変えたとき
      #
      # 変更後の NICK をメッセージ本文として扱う。
      # @param [Cinch::Message] m メッセージ
      def on_nick(m)
        user = m.user
        record_message_to_channels(m, user.channels) do |channel, irc_user|
          channel.nicks.create(irc_user: irc_user,
                               timestamp: m.time,
                               nick: user.last_nick,
                               message: user.nick)
        end
      end

      # TOPIC を受信したとき
      # @param [Cinch::Message] m メッセージ
      def on_topic(m)
        record_message(m) do |channel, irc_user|
          channel.topics.create!(irc_user: irc_user,
                                 timestamp: m.time,
                                 nick: m.user.nick,
                                 message: m.message)
        end
      end

      # NOTICE を受信したとき
      # @param [Cinch::Message] m メッセージ
      def on_notice(m)
        record_message(m) do |channel, irc_user|
          channel.notices.create!(irc_user: irc_user,
                                  timestamp: m.time,
                                  nick: m.user.nick,
                                  message: m.message)
        end
      end

      # PRIVMSG を受信したとき
      # @param [Cinch::Message] m メッセージ
      def on_privmsg(m)
        record_message(m) do |channel, irc_user|
          channel.privmsgs.create!(irc_user: irc_user,
                                  timestamp: m.time,
                                  nick: m.user.nick,
                                  message: m.message)
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
