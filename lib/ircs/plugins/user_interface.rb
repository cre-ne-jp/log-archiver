# vim: fileencoding=utf-8

require_relative 'base'

module LogArchiver
  module Plugin
    # バージョンを返す
    class UserInterface < Base
      include Cinch::Plugin

      set(plugin_name: 'UserInterface')
      self.prefix = '.log '

      # ログ公開URLを返す
      match('url', method: :url_list)
      match(/url list\b/, method: :url_list)
      match(/url today\b/, method: :url_today)
      match(/url yesterday\b/, method: :url_yesterday)
      match(%r(url ((?:19|20)\d{2}[-/][01]\d[-/][0-3]\d)), method: :url_date)
      # 記録しているかどうかの状態を返す
      match(/status/, method: :status)

      def initialize(*)
        super

        @config = config
        @base_url = config['URL']
      end

      # チャンネルのログ公開ページのURLを発言する
      # @param [Cinch::Message] m
      # @return [void]
      def url_list(m)
        header = ui_header('URL')

        channel = Channel.from_cinch_message(m)
        unless channel
          send_and_record_channel_not_registered(m, 'URL')
          return
        end

        channel_url =
          Rails.application.routes.url_helpers.channel_url(channel,
                                                           host: @base_url)
        send_and_record(m, "#{header}#{channel_url}")
      end

      # 今日のログのURLを発言する
      # @param [Cinch::Message] m
      # @return [void]
      def url_today(m)
        send_and_record_day_url(m) do |channel|
          ChannelBrowse::Day.today(channel)
        end
      end

      # 昨日のログのURLを発言する
      # @param [Cinch::Message] m
      # @return [void]
      def url_yesterday(m)
        send_and_record_day_url(m) do |channel|
          ChannelBrowse::Day.yesterday(channel)
        end
      end

      # 指定された日のログ公開URLを発言する
      # @param [Cinch::Message] m
      # @param [String] date 日付の指定
      # @return [void]
      def url_date(m, date)
        send_and_record_day_url(m) do |channel|
          ChannelBrowse::Day.new(channel: channel, date: date)
        end
      end

      # 現在のログ取得状況を返す
      # @param [Cinch::Message] m
      # @return [void]
      def status(m)
        channel = Channel.from_cinch_message(m)
        unless channel
          send_and_record_channel_not_registered(m, 'status')
          return
        end

        header = "#{ui_header('status')}#{m.channel} は"
        message =
          if channel.logging_enabled?
            "#{header}ログを記録しています"
          else
            "#{header}ログの記録を停止しています"
          end

        send_and_record(m, message)
      end

      private

      # 共通のヘッダ文字列を返す
      # @param [String] subcommand サブコマンド
      # @return [String]
      def ui_header(subcommand)
        # 設定は管理画面から変更される可能性があるので毎回読み込む
        setting = Setting.first

        "#{setting.site_title}<#{subcommand}>: "
      end

      # チャンネルが登録されていないことを発言・記録する
      # @param [Cinch::Message] m 受信したメッセージ
      # @param [String] subcommand
      # @return [void]
      def send_and_record_channel_not_registered(m, subcommand)
        header = ui_header(subcommand)
        send_and_record(m, "#{header}#{m.channel} は登録されていません")
      end

      # 1日分のログのURLを発言・記録する
      # @param [Cinch::Message] m 受信したメッセージ
      # @yieldparam channel [::Channel] チャンネル
      # @yieldreturn [ChannelBrowse::Day] 1日分の閲覧
      # @return [void]
      #
      # 1日分の閲覧を表す ChannelBrowse::Day インスタンスを返すブロックを
      # 渡して使う。ブロックにはチャンネルが渡される。ブロックで指定するのは
      # チャンネルが登録されていることの確認を先に行えるようにするため。
      #
      # 1日分の閲覧の属性が無効な場合は、日付指定に誤りがあることを
      # 発言・記録する。
      def send_and_record_day_url(m, &block)
        channel = Channel.from_cinch_message(m)
        unless channel
          send_and_record_channel_not_registered(m, 'URL')
          return
        end

        header = ui_header('URL')
        browse_day = block[channel]

        unless browse_day.valid?
          send_and_record(m, "#{header}日付指定が間違っています")
          return
        end

        send_and_record(m, "#{header}#{browse_day.url(@base_url)}")
      end
    end
  end
end
