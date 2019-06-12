# vim: fileencoding=utf-8

require 'cinch'
require 'lumberjack'
require 'optparse'
require 'sysexits'
require 'pp'

require_relative './config'
require_relative './plugins_loader'

module LogArchiver
  module Ircs
    extend self

    # プログラムを実行する
    # @param [Array<String>] argv コマンドライン引数の配列
    # @return [void]
    def run(root_path, argv)
      @root_path = root_path

      options = parse_options(argv)
      config_id = options[:config_id]
      log_level = options[:log_level]

      @logger = new_logger(log_level)
      config = load_config(config_id, options[:mode])
      plugins = load_plugins(%w(ChannelSync SaveLog KickBack LoginNickserv Version UserInterface Part Ctcp))

      bot = new_bot(config, plugins, log_level)

      @quit_message = config.irc_bot['QuitMessage']
      set_signal_handler(bot)
      bot.start

      @logger.warn('ボットは終了しました')
    end

    # オプションを解析する
    # @return [Hash]
    def parse_options(argv)
      default_options = {
        config_id: 'ircbot',
        log_level: :warn,
        mode: 'development'
      }
      options = {}

      OptionParser.new do |opt|
        opt.banner = "使用法: #{opt.program_name} [オプション]"

        opt.version = Application::VERSION_AND_COMMIT_ID

        opt.summary_indent = ' ' * 2
        opt.summary_width = 24

        opt.separator('')
        opt.separator('IRC Log Archiver (IRC ボット)')

        opt.separator('')
        opt.separator('オプション:')

        opt.on(
          '-c', '--config=CONFIG_ID',
          '設定 CONFIG_ID を読み込みます'
        ) do |config_id|
          options[:config_id] = config_id
        end

        opt.on(
          '-m', '--mode=RAILS_ENV',
          '環境を指定します'
        ) do |mode|
          options[:mode] = mode
        end

        opt.on(
          '-v', '--verbose',
          'ログを冗長にします'
        ) do
          options[:log_level] = :info
        end

        opt.on(
          '--debug',
          'デバッグモード。ログを最も冗長にします。'
        ) do
          options[:log_level] = :debug
        end

        opt.parse(argv)
      end

      default_options.merge(options)
    end

    # 設定を読み込む
    # @param [String] config_id 設定 ID
    # @param [String] mode 実行モード (RAILS_ENV)
    # @return [Config]
    def load_config(config_id, mode)
      config = Config.load_yaml_file(config_id, "#{@root_path}/config", mode)
      @logger.warn("設定 #{config_id} を読み込みました")

      config
    rescue => e
      @logger.fatal('設定ファイルの読み込みに失敗しました')
      @logger.fatal(e)

      Sysexits.exit(:config_error)
    end
    private :load_config

    # プラグインの IRC アダプタを読み込む
    # @param [Array<String>] plugin_names
    # @return [Array<Cinch::Plugin>] 読み込まれた IRC アダプタの配列
    def load_plugins(plugin_names)
      loader = PluginsLoader.new(plugin_names)
      plugins = loader.load_each

      plugins.each do |adapter|
        @logger.warn(
          "プラグイン #{adapter.plugin_name} を読み込みました"
        )
      end

      plugins
    rescue LoadError, StandardError => e
      @logger.fatal('プラグインの読み込みに失敗しました')
      @logger.fatal(e)

      Sysexits.exit(:config_error)
    end

    # 新しいロガーを作り、設定して返す
    # @param [Symbol] log_level ログレベル
    # @return [Logger]
    def new_logger(log_level)
      lumberjack_log_level =
        Lumberjack::Severity.const_get(log_level.upcase)

      Lumberjack::Logger.new(
        $stdout,
        progname: self.to_s,
        level: lumberjack_log_level
      )
    end

    # 新しい IRC ボットのインスタンスを生成する
    # @param [Config] config 設定
    # @param [Array]  plugins プラグインのクラス
    # @param [Symbol] log_level ログレベル
    # @return [Cinch::Bot]
    def new_bot(config, plugins, log_level)
      bot_config = config.irc_bot
      plugin_options = {}
      plugins.each do |p|
        plugin_options[p] = config.plugins[p.plugin_name] || {}
        plugin_options[p][:logger] = @logger
        plugin_options[p][:authentication_server] = config.authentication_server || ''
      end

      bot = Cinch::Bot.new do
        configure do |c|
          c.server = bot_config['Host']
          c.port = bot_config['Port']
          c.password = bot_config['Password']
          c.encoding = bot_config['Encoding'] || 'UTF-8'
          c.nick = bot_config['Nick']
          c.user = bot_config['User']
          c.realname = bot_config['RealName']
          c.channels = bot_config['Channels'] || []

          c.ssl.use = bot_config['SSL']

          c.plugins.plugins = plugins
          c.plugins.options = plugin_options
        end

        loggers.level = log_level
      end

      @logger.warn('ボットが生成されました')

      # return
      bot

    rescue => e
      @logger.fatal('ボットの生成に失敗しました')
      @logger.fatal(e)

      Sysexits.exit(:config_error)
    end

    # シグナルハンドラを設定する
    # @param [Cinch::Bot] bot IRC ボット
    # @return [void]
    def set_signal_handler(bot)
      # シグナルを捕捉し、ボットを終了させる処理
      # trap 内で普通に bot.quit すると ThreadError が出るので
      # 新しい Thread で包む
      %i(SIGINT SIGTERM).each do |signal|
        Signal.trap(signal) do
          Thread.new(signal) do |sig|
            bot.quit(@quit_message.empty? ? "Caught #{sig}" : @quit_message)
          end
        end
      end
    end
  end
end
