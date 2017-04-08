namespace :data do
  namespace :channel_last_speeches do
    desc '最後の発言を更新する'
    task :update => :environment do
      con = ActiveRecord::Base.connection

      # チャンネルごとの最終発言のIDを取得する
      channel_id_conversation_message_ids = con.execute(
        'SELECT t1.channel_id, MAX(t1.id) FROM conversation_messages t1 ' \
        'JOIN (' \
        'SELECT channel_id, MAX(timestamp) AS timestamp FROM conversation_messages GROUP BY channel_id' \
        ') AS t2 ' \
        'ON t1.channel_id = t2.channel_id AND t1.timestamp = t2.timestamp ' \
        'GROUP BY t1.channel_id'
      ).to_a

      channel_id_conversation_message_ids.each do |values|
        begin
          channel_id, conversation_message_id = values

          ActiveRecord::Base.transaction do
            channel = Channel.find(channel_id)
            message = ConversationMessage.find(conversation_message_id)

            channel_last_speech =
              ChannelLastSpeech.find_or_initialize_by(channel: channel)
            channel_last_speech.conversation_message = message

            channel_last_speech.save!

            puts(
              "#{channel.name_with_prefix}: " \
              "最終発言 #{message.timestamp.strftime('%F %T')}"
            )
          end

        rescue => e
          puts("チャンネル ID #{channel_id}: #{e}")
        end
      end
    end
  end
end
