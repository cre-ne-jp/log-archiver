# vim: fileencoding=utf-8

require_relative 'base'
require_relative '../irc_bot_version'

require 'time'

module LogArchiver
  module Plugin
    # CTCP を返す
    # @see https://tools.ietf.org/id/draft-oakley-irc-ctcp-01.html
    class Ctcp < Base
      include Cinch::Plugin

      set(plugin_name: 'Ctcp')

      # CTCP を返す
      ctcp(:clientinfo)
      ctcp(:userinfo)
      ctcp(:version)
      ctcp(:ping)
      ctcp(:source)
      ctcp(:time)

      # CLIENTINFO (対応するCTCPの一覧)に応答する
      # @param [Cinch::Message] m
      # @return [void]
      def ctcp_clientinfo(m)
        valid_cmds = %w(CLIENTINFO VERSION PING SOURCE TIME).sort
        ctcp_reply(m, valid_cmds.join(' '))
      end

      # USERINFO に応答する
      # @param [Cinch::Message] m
      # @return [void]
      def ctcp_userinfo(m)
        app_status = Rails.application.config.app_status
        ctcp_reply(m, "稼働時間: #{app_status.formatted_uptime} (#{app_status.start_time.strftime('%F %T')} に起動)")
      end

      # VERSION に応答する
      # @param [Cinch::Message] m
      # @return [void]
      def ctcp_version(m)
        ctcp_reply(m, Ircs::APP_NAME_VERSION_COMMIT_ID)
      end

      # PING に応答する
      # @param [Cinch::Message] m
      # @return [void]
      def ctcp_ping(m)
        ctcp_reply(m, m.ctcp_args.join(' '))
      end

      # SOURCE に応答する
      # @param [Cinch::Message] m
      # @return [void]
      def ctcp_source(m)
        ctcp_reply(m, 'https://github.com/cre-ne-jp/log-archiver')
      end

      # TIME に応答する
      # @param [Cinch::Message] m
      # @return [void]
      #
      # RFC 2822で定義されている形式で現在の日時を返す。
      #
      # 応答例: "Sun, 03 Feb 2019 09:52:57 +0900"
      def ctcp_time(m)
        ctcp_reply(m, Time.now.rfc2822)
      end

      private

      # CTCP に応答する
      # @param [Cinch::Message] m
      # @param [String] message 応答内容
      # @return [void]
      def ctcp_reply(m, message)
        m.ctcp_reply(message)
        @logger.warn("<CTCP(#{m.ctcp_command}):#{m.user.nick}>: #{message}")
      end
    end
  end
end
