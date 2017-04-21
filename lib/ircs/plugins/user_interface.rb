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
      match(/url (today|yesterday)\b/, method: :url)
      match(%r(url ((?:19|20)\d{2}[-/][01]\d[-/][0-3]\d)), method: :url)
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

      # ログ公開URLを発言する
      # @param [Cinch::Message] m
      # @param [String] day 日付の指定
      # @return [void]
      def url(m, day)
        header = "#{@header}<URL>: "

        channel = Channel.from_cinch_message(m)
        unless channel
          send_and_record(m, "#{header}#{m.channel} は登録されていません")
          return
        end
        result = "#{header}#{@config['URL']}/channels/#{channel.identifier}"

        date = case(day)
          when 'today'
            Date.today
          when 'yesterday'
            Date.today.prev_day
          else
            begin
              Date.parse(day)
            rescue ArgumentError => e
              send_and_record(m, "#{header}日付指定が間違っています")
              return
            end
          end

        send_and_record(m, "#{result}/#{date.strftime('%Y/%m/%d')}")
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
