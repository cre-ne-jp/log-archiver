class DropForeignKeyFromChannelLastSpeechesToConversationMessagesIfExists < ActiveRecord::Migration[6.1]
  def change
    if foreign_key_exists?(:channel_last_speeches, :conversation_messages)
      remove_foreign_key(:channel_last_speeches, :conversation_messages)
    end
  end
end
