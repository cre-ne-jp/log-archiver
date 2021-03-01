class DropForeignKeyFromChannelLastSpeechesToConversationMessagesIfExists < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key(:channel_last_speeches, :conversation_messages)
  end
end
