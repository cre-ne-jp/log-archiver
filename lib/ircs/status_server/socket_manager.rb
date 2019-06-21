module LogArchiver
  module Ircs
    class StatusServer
      class SocketManager
        attr_reader :server_socket

        def initialize(server_socket, logger)
          @server_socket = server_socket
          @logger = logger

          @client_socket_fd_map = Hash.new
        end

        def sockets
          [@server_socket] + @client_socket_fd_map.keys
        end

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

        def close_all_client_sockets
          @client_socket_fd_map.keys.each do |socket|
            close(socket, log: true)
          end
        end
      end
    end
  end
end
