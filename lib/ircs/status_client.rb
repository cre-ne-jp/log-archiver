# frozen_string_literal: true

require 'socket'
require 'json'
require 'timeout'

module LogArchiver
  module Ircs
    # IRCボットの現在の状態を問い合わせるクライアントのクラス
    class StatusClient
      # クライアントを初期化する
      # @param [String] socket_path ソケットファイルのパス
      # @param [logger] logger ロガー
      def initialize(socket_path, logger)
        @socket_path = socket_path
        @logger = logger
      end

      # IRCボットの現在の状態を取得する
      # @param [Numeric] timeout_s タイムアウトまでの秒数
      # @return [Hash]
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

      # ソケットからIRCボットの現在の状態を取得する
      # @param [Socket] socket ソケット
      # @return [Hash]
      def fetch_status_from(socket)
        socket.puts('status')
        response = socket.gets
        socket.shutdown

        response
      end
    end
  end
end
