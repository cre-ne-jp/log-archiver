# vim: fileencoding=utf-8

require 'xmlrpc/client'

require_relative 'base'

module LogArchiver
  module Plugin
    # バージョンを返す
    class UserInterface < Base
      include Cinch::Plugin

      set(plugin_name: 'UserInterface')
      self.prefix = '.la-ui '

      match(/url(?:$| (today|yesterday|list))/, method: :url)
      match(%r(url ((?:19|20)\d{2}[-/][01]\d[-/][0-3]\d)), method: :url)
      match(/status/, method: :status)

      def initialize(*)
        super

        @setting = Setting.find(1)
        @header = "#{@setting.site_title}"

        @config = config
      end

      # ログ公開URLを発言する
      # @param [Cinch::Message] m
      # @param [String] day 日付の指定
      # @return [void]
      def url(m, day)
        header = "#{@header}<URL>: "

        unless channel = ::Channel.find_by(name: m.channel.name[1..-1])
          send_and_record(m, "#{header}#{m.channel} は登録されていません")
          return
        end
        result = "#{header}#{@config['URL']}/channels/#{channel.identifier}"

        date = case(day)
          when 'list'
            send_and_record(m, result)
            return
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

        if channel = ::Channel.find_by(name: m.channel.name[1..-1])
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
