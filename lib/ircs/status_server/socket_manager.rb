module LogArchiver
  module Ircs
    class StatusServer
      # IRCボットの現在の状態を返すサーバで使うソケットの管理を担うクラス。
      #
      # サーバ終了時にすべてのクライアントソケットを閉じる機能、
      # クライアントとファイル記述子との対応を管理する機能を持つ。
      # クライアントと対応するファイル記述子をログに記録することで、
      # 問題発生時にどのクライアントとの通信で発生しているかを判断しやすくする。
      class SocketManager
        # @return [Socket] server_socket 接続受け入れ用ソケット
        attr_reader :server_socket

        # ソケット管理を初期化する
        # @param [Socket] server_socket 接続受け入れ用ソケット
        # @param [Object] logger ロガー
        def initialize(server_socket, logger)
          @server_socket = server_socket
          @logger = logger

          # クライアントのソケットとファイル記述子との対応
          # @type [Hash<Socket, Integer>]
          @client_socket_fd_map = {}
        end

        # サーバの接続受け入れ用ソケットとクライアントのソケットを合わせた
        # 配列を返す
        # @return [Array<Socket>]
        def sockets
          [@server_socket] + @client_socket_fd_map.keys
        end

        # 接続を受け入れる
        # @return [void]
        def accept_connection
          begin
            client_socket, _ = @server_socket.accept
          rescue => e
            @logger.error("SocketManager#accept_connection: #{e}")
            return
          end

          fd = client_socket.fileno
          @client_socket_fd_map[client_socket] = fd
          @logger.info("SocketManager: クライアント (fd #{fd}) からの接続を受け付けました")
        end

        # クライアントのソケットからコマンドを読み込む
        # @param [Socket] socket クライアントのソケット
        # @return [String] 読み取りに成功した場合、読み取られたコマンド
        # @return [nil] 読み取りに失敗した場合
        def read_command(socket)
          fd = @client_socket_fd_map[socket]

          begin
            line = socket.gets
          rescue => e
            close(socket)
            @logger.error("SocketManager#read_command: クライアント (fd #{fd}): #{e}")

            return nil
          end

          unless line
            # おそらくクライアント側でソケットが閉じられている
            close(socket, log: true)
            return nil
          end

          command = line.chomp
          @logger.debug("SocketManager: クライアント (fd #{fd}) >> #{command}")

          command
        end

        # クライアントに対して返信する
        # @param [String] response 返信内容
        # @param [Socket] socket クライアントのソケット
        # @return [void]
        def reply(response, socket)
          fd = @client_socket_fd_map[socket]

          begin
            @logger.debug("SocketManager: クライアント (fd #{fd}) << #{response}")
            socket.puts(response)
          rescue => e
            close(socket)
            @logger.error("SocketManager#reply: クライアント (fd #{fd}): #{e}")
          end
        end

        # すべてのクライアントソケットを閉じる
        # @return [void]
        def close_all_client_sockets
          @client_socket_fd_map.keys.each do |socket|
            close(socket, log: true)
          end
        end

        private

        # クライアントのソケットを閉じる
        # @param [Socket] socket クライアントのソケット
        # @param [Boolean] log 結果をログに記録するかどうか
        def close(socket, log: false)
          fd = @client_socket_fd_map[socket]

          begin
            socket.shutdown
            socket.close
          rescue => e
            @logger.error("SocketManager#close: クライアント (fd #{fd}): #{e}")
          end

          @client_socket_fd_map.delete(socket)

          if log
            @logger.info("SocketManager#close: クライアント (fd #{fd}) からの接続を閉じました")
          end
        end
      end
    end
  end
end
