require 'socket'
require 'json'
require 'timeout'

module LogArchiver
  module Ircs
    class StatusClient
      def initialize(socket_path, logger)
        @socket_path = socket_path
        @logger = logger
      end

      def fetch_status(timeout_s)
        json = Timeout.timeout(timeout_s) do
          UNIXSocket.open(@socket_path) do |socket|
            fetch_status_from(socket)
          end
        end

        response_hash = JSON.parse(json, symbolize_names: true)
        unless response_hash.dig(:ok)
          raise response_hash.dig(:error)
        end

        irc_bot_status_hash = response_hash.dig(:result)
        AppStatus.from_hash(irc_bot_status_hash)
      end

      def fetch_status_from(socket)
        socket.puts('status')
        response = socket.gets
        socket.shutdown

        response
      end
    end
  end
end
