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

        @setting = Setting.find(1)
        @header = "#{@setting.site_title}"

        @config = config
        @base_url = config['URL']
      end

      # チャンネルのログ公開ページのURLを発言する
      # @param [Cinch::Message] m
      # @return [void]
      def url_list(m)
        header = "#{@header}<URL>: "

        channel = Channel.from_cinch_message(m)
        unless channel
          send_and_record(m, "#{header}#{m.channel} は登録されていません")
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
        header = "#{@header}<URL>: "

        channel = Channel.from_cinch_message(m)
        unless channel
          send_and_record(m, "#{header}#{m.channel} は登録されていません")
          return
        end

        today = ChannelBrowse::Day.today(channel)
        send_and_record(m, "#{header}#{today.url(@base_url)}")
      end

      # 昨日のログのURLを発言する
      # @param [Cinch::Message] m
      # @return [void]
      def url_yesterday(m)
        header = "#{@header}<URL>: "

        channel = Channel.from_cinch_message(m)
        unless channel
          send_and_record(m, "#{header}#{m.channel} は登録されていません")
          return
        end

        yesterday = ChannelBrowse::Day.yesterday(channel)
        send_and_record(m, "#{header}#{yesterday.url(@base_url)}")
      end

      # 指定された日のログ公開URLを発言する
      # @param [Cinch::Message] m
      # @param [String] date 日付の指定
      # @return [void]
      def url_date(m, date)
        header = "#{@header}<URL>: "

        channel = Channel.from_cinch_message(m)
        unless channel
          send_and_record(m, "#{header}#{m.channel} は登録されていません")
          return
        end

        browse_day = ChannelBrowse::Day.new(channel: channel, date: date)

        unless browse_day.valid?
          send_and_record(m, "#{header}日付指定が間違っています")
          return
        end

        send_and_record(m, "#{header}#{browse_day.url(@base_url)}")
      end

      # 現在のログ取得状況を返す
      # @param [Cinch::Message] m
      # @return [void]
      def status(m)
        header = "#{@header}<status>: #{m.channel} は"

        channel = Channel.from_cinch_message(m)
        if channel
          if channel.logging_enabled?
            send_and_record(m, "#{header}ログを記録しています")
          else
            send_and_record(m, "#{header}ログの記録を停止しています")
          end
        else
          send_and_record(m, "#{header}登録されていません")
        end
      end
    end
  end
end
