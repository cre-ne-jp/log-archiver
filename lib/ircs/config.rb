# vim: fileencoding=utf-8

require 'yaml'

module LogArchiver
  # IRC ボットの設定を表すクラス
  class Config
    # IRC ボットの設定のハッシュ
    # @return [Hash]
    attr_reader :irc_bot
    # プラグインの設定
    # @return [Array<Hash>]
    attr_reader :plugins

    class << self
      # 設定 ID から設定ファイルのパスに変換する
      # @param [String] config_id 設定 ID
      # @param [String] root_path 設定ファイルのルートディレクトリのパス
      # @return [String] 設定ファイルのパス
      def config_id_to_path(config_id, root_path)
        if config_id.include?('../')
          fail(ArgumentError, "#{config_id}: ディレクトリトラバーサルの疑い")
        end

        "#{root_path}/#{config_id}.yml"
      end

      # YAML 形式の設定ファイルを読み込み、オブジェクトに変換する
      # @param [String] config_id 設定 ID
      # @param [String] root_path 設定ファイルのルートディレクトリのパス
      # @return [RGRB::Config]
      def load_yaml_file(config_id, root_path, mode)
        config_path = config_id_to_path(config_id, root_path)
        config_data = YAML.load_file(config_path)[mode]

        new(config_data)
      end
    end

    # 新しい RGRB::Config インスタンスを返す
    # @param [Hash] config_data 設定データのハッシュ
    # @return [RGRB::Config]
    def initialize(config_data)
      @irc_bot = config_data['IRCBot']
      @plugins = config_data['Plugins'] || []
    end
  end
end
