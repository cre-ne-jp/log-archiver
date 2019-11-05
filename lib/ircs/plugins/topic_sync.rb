# vim: fileencoding=utf-8

require_relative 'base'

module LogArchiver
  module Plugin
    # JOIN したチャンネルの TOPIC がデータベースに保存されているか確認する
    class TopicSync < Base
      include Cinch::Plugin

      set(plugin_name: 'TopicSync')

      listen_to(333, method: :get_topic_metadatas)

      def initialize(*args)
        super

        config_data = config[:plugin] || {}
      end

      # チャンネルに JOIN したときの Numeric Reply 333 から、
      # チャンネルが作成されたタイムスタンプと作成者を取得する
      # @param [Cinch::Message] m
      # @return [void]
      def get_topic_metadatas(m)
        return if m.channel.topic == ''

        _, nick, user, host = m.params[2].match(/\A(.+)!(.+)@(.+)\z/).to_a
        timestamp = Time.zone.at(m.params[3].to_i)
        save_topic(m.channel, nick, user, host, timestamp)
      end

      private

      # TOPIC を保存する
      # @params [Cinch::Target] m_channel
      # @params [String] nick
      # @params [String] user
      # @params [String] host
      # @params [Time] timestamp
      # @return [void]
      def save_topic(m_channel, nick, user, host, timestamp)
        synchronize(RECORD_MESSAGE) do
          ActiveRecord::Base.connection_pool.with_connection do
            channel = ::Channel.find_by(name: m_channel.name[1..-1],
                                        logging_enabled: true)
            next nil unless channel

            ActiveRecord::Base.transaction do
              irc_user = IrcUser.find_or_create_by!(user: user, host: host)
              topic = channel.topics.find_or_create_by!(
                irc_user: irc_user,
                timestamp: timestamp,
                nick: nick,
                message: m_channel.topic
              )
              update_last_speech!(channel, topic)
              MessageDate.find_or_create_by!(channel: channel, date: timestamp)
            end
          end
        end
      end
    end
  end
end
