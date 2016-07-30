# vim: fileencoding=utf-8

module LogArchiver
  module Plugin
    # DB からチャンネル情報を読み出し、設定と実際の接続状態を比較する
    # 必要なチャンネルに JOIN し、不要なチャンネルから PART する
    class ChannelSync
      include Cinch::Plugin

      set(plugin_name: 'ChannelSync')

      # ログ取得が有効なチャンネル
      attr_reader :enable_channels
      # ログ取得が無効なチャンネル
      attr_reader :disable_channels

      match(:connect, method: :kickstart)
      timer(60, method: :kickstart)

      # 一定間隔で実行する
      # @return [void]
      def kickstart
        @enable_channels, @disable_channels = load_channel_setting

        compare_channels(@enable_channels, @disable_channels)
      end

      # データベースから現在のチャンネル設定を読み込む
      # @return [Array<Array>]
      # @option [Array] ログ取得が有効なチャンネル
      # @option [Array] ログ取得が無効なチャンネル
      def load_channel_setting
        [enable, disable]
      end

      def initialize(bot)
        @enable_channels = []
        @disable_channels = []
      end
    end
  end
end
