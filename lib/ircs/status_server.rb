require 'ircs/status_server/socket_manager'

require 'socket'
require 'json'

module LogArchiver
  module Ircs
    # IRCボットの現在の状態を返すサーバのクラス
    class StatusServer
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
      }

      def initialize(socket_path, logger)
        @socket_path = socket_path
        @logger = logger
      end

      def start_thread(signal_io_r)
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

      def response_to(command)
        command_hash = { command: command }
        response_generator = RESPONSE_GENERATOR[command]
        response_body =
          response_generator&.call || response_to_invalid_command(command)

        command_hash.merge(response_body)
      end

      def response_to_invalid_command(command)
        {
          ok: false,
          error: "Invalid command: #{command}"
        }
      end

      private

      def handle_readable_ios(signal_io_r, socket_manager)
        ios = [signal_io_r] + socket_manager.sockets
        readable_ios, _ = IO.select(ios)
        readable_ios.each do |io|
          case io
          when signal_io_r
            stop = dispatch_signal_related_command(io)
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

        false
      end

      def dispatch_signal_related_command(io)
        command = io.getc
        @logger.debug("StatusServer#dispatch_signal_related_command: コマンド #{command}")

        if command == 'q'
          @logger.debug('終了要求を受信しました')
          return true
        end

        false
      end
    end
  end
end
