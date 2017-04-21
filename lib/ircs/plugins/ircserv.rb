# vim: fileencoding=utf-8

require 'xmlrpc/client'

# IRC 管理・運営サービス Atheme-Services に、XMLRPC 経由でアクセスする
class IrcServ
  # 管理サービス側のログファイルに残る識別子
  # 必ずしも IP アドレスである必要はない、らしい
  SOURCE_IP = 'log-archiver'

  # 管理サービスにログインする
  # @param [String] address 管理サービスのURL
  # @param [String] nick ログイン名
  # @param [String] password パスワード
  # @return [void]
  def initialize(address, nick, password)
    @nick = nick
    @client = XMLRPC::Client.new2(address)

    @authcookie = @client.call('atheme.login', nick, password, SOURCE_IP)
  end

  # 管理サービスからログアウトする
  # @return [Boolean]
  def logout
    @client.call('atheme.logout', @authcookie, @nick) == ''
  end

  # コマンドを実行する
  # @param [Symbol] service 実行するコマンドのサービス
  # @param [String] command 実行するコマンド名
  # @param [Array<String>] params コマンドの引数
  # @return [String]
  def command(service, command, params)
    target = case(service)
    when :nick, :nickserv
      'nickserv'
    when :chan, :chanserv
      'chanserv'
    when :oper, :operserv
      'operserv'
    else
      raise 'サービスが指定されていません'
    end

    @client.call('atheme.command', @authcookie, @nick, SOURCE_IP, target, params)
  end
end
