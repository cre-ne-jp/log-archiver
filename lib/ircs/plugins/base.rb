# vim: fileencoding=utf-8

module LogArchiver
  module Plugin
    # プラグインのひな形
    class Base
      include Cinch::Plugin

      RECORD_MESSAGE = :record_message

      # データベース接続インスタンスをクラス変数に格納する
      def initialize(*args)
        super

        @logger = config[:logger]
      end

      # IRC へ発言し、データベースに保存する
      # このメソッドを経由しないと、自分自身の発言が保存できない
      # @param [Cinch::Message] m
      # @param [String] message 送信するメッセージ
      # @return [void]
      def send_and_record(m, message)
        m.target.send(message, true)
        @logger.warn("<#{m.channel}>: #{message}")

        sleep 0.1

        synchronize(RECORD_MESSAGE) do
          ActiveRecord::Base.connection_pool.with_connection do
            channel = ::Channel.find_by(
              name: m.channel.name[1..-1],
              logging_enabled: true
            )
            next nil unless channel

            ActiveRecord::Base.transaction do
              irc_user = IrcUser.find_or_create_by!(user: bot.user, host: bot.host)
              notice = channel.notices.create!(
                irc_user: irc_user,
                timestamp: m.time,
                nick: bot.nick,
                message: message
              )
              update_last_speech!(channel, notice)
              MessageDate.find_or_create_by!(channel: channel, date: m.time.to_date)
            end
          end
        end
      end

      private

      # メッセージを記録する
      # @param [Cinch::Message] message Cinch から渡された IRC メッセージ
      # @yieldparam [::Channel] channel チャンネル
      # @yieldparam [IrcUser] irc_user IRC ユーザー
      # @return [void]
      def record_message(message)
        return nil unless message.channel

        synchronize(RECORD_MESSAGE) do
          ActiveRecord::Base.connection_pool.with_connection do
            channel = ::Channel.find_by(name: message.channel.name[1..-1],
                                        logging_enabled: true)
            next nil unless channel

            next nil unless user = message.user

            ActiveRecord::Base.transaction do
              irc_user = IrcUser.find_or_create_by!(user: user.user, host: user.host)
              yield(channel, irc_user)
              MessageDate.find_or_create_by!(channel: channel, date: message.time.to_date)
            end
          end
        end
      end

      # 複数のチャンネルにメッセージを記録する
      # @param [Cinch::Message] message Cinch から渡された IRC メッセージ
      # @param [Array<Cinch::Channel>] cinch_channels Cinch から渡されたチャンネルリスト
      # @yieldparam [::Channel] channel チャンネル
      # @yieldparam [IrcUser] irc_user IRC ユーザー
      # @return [void]
      def record_message_to_channels(message, cinch_channels)
        channel_names_without_prefix =
          cinch_channels.map { |channel| channel.name[1..-1] }

        ActiveRecord::Base.connection_pool.with_connection do
          synchronize(RECORD_MESSAGE) do
            irc_user = nil
            next [] unless user = message.user
            channels = ::Channel.where(name: channel_names_without_prefix,
                                       logging_enabled: true)
            channels.each.map do |channel|
              ActiveRecord::Base.transaction do
                irc_user ||= IrcUser.find_or_create_by!(user: user.user,
                                                        host: user.host)
                yield(channel, irc_user)
                MessageDate.find_or_create_by!(channel: channel, date: message.time.to_date)
              end
            end
          end
        end
      end

      # チャンネルごとの最終発言を更新する
      # @param [::Channel] チャンネル
      # @param [::ConversationMessage] 発言のメッセージ
      # @return [::ChannelLastSpeech]
      def update_last_speech!(channel, message)
        channel_last_speech =
          ChannelLastSpeech.find_or_initialize_by(channel: channel)
        channel_last_speech.conversation_message = message
        channel_last_speech.save!
      end
    end
  end
end
