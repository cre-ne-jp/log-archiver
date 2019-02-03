# vim: fileencoding=utf-8

require_relative 'base'

module LogArchiver
  module Plugin
    # CTCP を返す
    # @see https://tools.ietf.org/id/draft-oakley-irc-ctcp-01.html
    class Ctcp < Base
      include Cinch::Plugin

      set(plugin_name: 'Ctcp')

      # CTCP を返す
      ctcp(:clientinfo)
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

      # VERSION に応答する
      # @param [Cinch::Message] m
      # @return [void]
      def ctcp_version(m)
        ctcp_reply(m, "log-archiver_ircbot #{Application.version_and_commit_id}")
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
      def ctcp_time(m)
        ctcp_reply(m, Time.now.strftime('%a, %d %b %Y %T %z'))
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
