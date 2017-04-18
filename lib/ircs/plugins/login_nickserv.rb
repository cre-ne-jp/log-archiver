# vim: fileencoding=utf-8

require 'cinch'
require 'xmlrpc/client'

require_relative 'base'

module LogArchiver
  module Plugin
    # NickServ にログインする
    class LoginNickserv < Base
      include Cinch::Plugin

      set(plugin_name: 'LoginNickserv')
      self.prefix = ''
      self.react_on = :notice

      # ホスト名を表す正規表現
      # @see http://stackoverflow.com/questions/106179/regular-expression-to-match-dns-hostname-or-ip-address
      HOSTNAME_RE =
        /(?:[a-z\d](?:[-a-z\d]{0,61}[a-z\d])?
          (?:\.[a-z\d](?:[-a-z\d]{0,61}[a-z\d])?)*)/ix
      # サーバーがネットワークに参加したときのメッセージを表す正規表現
      NETJOIN_RE =
        /^\*\*\* Notice -- Netjoin #{HOSTNAME_RE} <-> (#{HOSTNAME_RE})/o

      # サーバーがネットワークに参加したときのメッセージを表す正規表現
      match(NETJOIN_RE, method: :joined)
      # サーバーへの接続が完了したときに情報を集める
      listen_to(:'002', method: :connected)

      def initialize(*)
        super

        @nickserv = config['NickServ']
        @login_server = {
          irc: config['LoginServer'],
          xmlrpc: config['XMLRPC'] || ''
        }
        @myself = config['Account']
      end

      # サーバ接続メッセージを検知し、NickServ サーバならログインする
      # @param [Cinch::Message] m メッセージ
      # @param [String] server サーバ
      # @return [void]
      def joined(m, server)
        if m.server && server == @login_server[:irc]
          @logger.warn("#{server} がリレーしました")
          login
        end
      end

      # サーバに接続したとき、NickServ にログインする
      # @param [Cinch::Message] m メッセージ
      # @return [void]
      def connected(m)
        login
      end

      private

      # NickServ にログインする
      # @return [void]
      def login
        sleep 1
        Cinch::UserList.new(@bot).find_ensured(
          @nickserv['User'],
          @nickserv['Nick'],
          @nickserv['Host']
        ).send("IDENTIFY #{@myself['Nick']} #{@myself['Pass']}", false)
        @logger.warn("NickServ へのログインを試行しました")

        sleep 1
        begin
          if(logged_in?)
            @logger.warn('NickServ にログインしました')
          else
            @logger.error('NickServ にログインできませんでした')
          end
        rescue
          @logger.error('ログイン時にエラーが発生しました')
        end
      end

      # NickServ に自分自身がログインできているか確認する
      # @return [Boolean]
      def logged_in?
        client = XMLRPC::Client.new2(@login_server[:xmlrpc])

        begin
          authcookie = client.call('atheme.login', @myself['Nick'], @myself['Pass'])
          result = client.call('atheme.command', authcookie, @myself['Nick'], 'srv5.cre.ne.jp', 'nickserv', 'info', @myself['Nick'])
          client.call('atheme.logout', authcookie, @myself['Nick'])
        rescue => e
          @logger.warn('XMLRPC からデータ取得に失敗しました')
          @logger.warn("FaultCode: #{e.faultCode}, Message: #{e.faultString}")
          raise e
        end

        m = result.match(/^Logins from: (.+)$/)
        if(m)
          m[1].split.include?(@bot.nick)
        else
          false
        end
      end
    end
  end
end
