# frozen_string_literal: true

require 'ircs/status_server/socket_manager'

require 'socket'
require 'json'

module LogArchiver
  module Ircs
    # IRCボットの現在の状態を返すサーバのクラス
    class StatusServer
      # 応答生成処理
      # @type [Hash<String, Proc>]
      RESPONSE_GENERATOR = {
        'ping' => -> {
          {
            ok: true,
            result: 'pong'
          }
        },

        'status' => -> {
          {
            ok: true,
            result: Rails.application.config.app_status.to_h
          }
        }
      }.freeze

      # サーバを初期化する
      # @param [String] socket_path ソケットファイルのパス
      # @param [Object] logger ロガー
      def initialize(socket_path, logger)
        @socket_path = socket_path
        @logger = logger
      end

      # サーバスレッドを開始する
      # @param [IO] signal_io_r シグナル関連コマンドの読み取り用IO
      # @return [Thread] サーバスレッド
      def start_thread(signal_io_r)
        if File.exist?(@socket_path)
          raise Errno::EEXIST, @socket_path
        end

        Thread.new do
          Socket.unix_server_socket(@socket_path) do |server_socket|
            @logger.info("StatusServer: UNIXドメインソケット " \
                         "#{@socket_path} を使用して通信します")

            socket_manager = SocketManager.new(server_socket, @logger)

            loop do
              stop = handle_readable_ios(signal_io_r, socket_manager)
              break if stop
            end

            socket_manager.close_all_client_sockets
          end
        end
      end

      # 受信したコマンドへの応答を返す
      # @param [String] command コマンド
      # @return [Hash]
      def response_to(command)
        command_hash = { command: command }
        response_generator = RESPONSE_GENERATOR[command]

        # コマンドに対応する処理があればそれを呼び出して結果を受け取り、
        # なければ無効なコマンドであることを示す応答とする
        response_body =
          response_generator&.call || response_to_invalid_command(command)

        command_hash.merge(response_body)
      end

      # 無効なコマンドへの応答を返す
      # @param [String] command コマンド
      # @return [Hash]
      def response_to_invalid_command(command)
        {
          ok: false,
          error: "Invalid command: #{command}"
        }
      end

      private

      # 読み込み用IOに対する処理
      # @param [IO] signal_io_r シグナル関連コマンドの読み取り用IO
      # @param [SocketManager] socket_manager ソケット管理
      # @return [true] サーバ終了要求を受信した場合
      # @return [false] サーバを終了する必要がない場合
      def handle_readable_ios(signal_io_r, socket_manager)
        ios = [signal_io_r] + socket_manager.sockets

        # 読み取りの準備ができたIOを選ぶ
        readable_ios, _ = IO.select(ios)
        readable_ios.each do |io|
          case io
          when signal_io_r
            stop = dispatch_signal_related_command(io)
            # 終了要求を受信した場合、サーバを終了する
            return true if stop
          when socket_manager.server_socket
            socket_manager.accept_connection
          else
            command = socket_manager.read_command(io)
            if command
              json = JSON.dump(response_to(command))
              socket_manager.reply(json, io)
            end
          end
        end

        # サーバを終了する必要がない
        false
      end

      # シグナル関連コマンドを呼び出す
      # @param [IO] io シグナル関連コマンドの読み取り用IO
      # @return [true] サーバ終了要求を受信した場合
      # @return [false] サーバを終了する必要がない場合
      def dispatch_signal_related_command(io)
        command = io.getc
        @logger.debug("StatusServer#dispatch_signal_related_command: コマンド #{command}")

        if command == 'q'
          @logger.debug('終了要求を受信しました')
          return true
        end

        # サーバを終了する必要がない
        false
      end
    end
  end
end
