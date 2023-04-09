class DropForeignKeyFromChannelLastSpeechesToConversationMessagesIfExists < ActiveRecord::Migration[6.1]
  def change
    return until foreign_key_exists?(:channel_last_speeches, column: :conversation_messages)
    remove_foreign_key(:channel_last_speeches, :conversation_messages)
  end
end
