# vim: fileencoding=utf-8

require 'xmlrpc/client'

# IRC 管理・運営サービス Atheme-Services に、XMLRPC 経由でアクセスする
class IrcServ
  # 管理サービス側のログファイルに残る識別子
  # 必ずしも IP アドレスである必要はない、らしい
  SOURCE_IP = 'log-archiver'

  # XMLRPC のエラーが発生したときのエラーコードとメッセージを保存する
  # @fault = {
  #   code: エラーコード
  #   message: エラーメッセージ
  # }
  attr_reader :fault

  # 管理サービスにログインする
  # @param [String] address 管理サービスのURL
  # @param [String] nick ログイン名
  # @param [String] password パスワード
  # @return [void]
  def initialize(address, nick, password)
    @nick = nick
    @fault = {code: nil, message: nil}

    @client = XMLRPC::Client.new2(address)

    begin
      @authcookie = @client.call('atheme.login', nick, password, SOURCE_IP)
      fault(true, nil)
    rescue XMLRPC::FaultException => e
      fault(e.faultCode, e.faultString)
    rescue => e
      fault(nil, e)
    end
  end

  # コマンドを実行する
  # @param [Symbol] service 実行するコマンドのサービス
  # @param [String] command 実行するコマンド名
  # @param [Array<String>] params コマンドの引数
  # @option [String/nil] :depends サービスから返された結果(失敗したら nil)
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

    begin
      @client.call('atheme.command', @authcookie, @nick, SOURCE_IP, target, params)
    rescue XMLRPC::FaultException => e
      fault(e.faultCode, e.faultString)
      nil
    rescue => e
      fault(nil, e)
      nil
    end
  end

  # 管理サービスからログアウトする
  # @return [String/false]
  def logout
    begin
      @client.call('atheme.logout', @authcookie, @nick)
    rescue XMLRPC::FaultException => e
      fault(e.faultCode, e.faultString)
      nil
    rescue => e
      fault(nil, e)
      nil
    end
  end

  # エラーメッセージを保存する
  # @param [Integer/nil] code エラーコード(XMLRPC のエラー以外は nil)
  # @param [String] message エラーメッセージ
  # @return [void]
  def fault(code, message)
    @fault[:code] = code
    @fault[:message] = message
  end
end
