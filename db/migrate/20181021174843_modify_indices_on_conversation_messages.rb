class ModifyIndicesOnConversationMessages < ActiveRecord::Migration[5.2]
  def change
    remove_index :conversation_messages, [:channel_id, :timestamp]
    remove_index :conversation_messages, :channel_id
    remove_index :conversation_messages, [:id, :channel_id, :timestamp]
    remove_index :conversation_messages, [:id, :channel_id]
    remove_index :conversation_messages, [:id, :timestamp]
    remove_index :conversation_messages, [:irc_user_id]
    remove_index :conversation_messages, :message
    remove_index :conversation_messages, [:nick, :message]
    remove_index :conversation_messages, :nick
    remove_index :conversation_messages, :timestamp
    remove_index :conversation_messages, :type

    add_index :conversation_messages, [:timestamp, :channel_id, :type], name: 'index_cm_on_timestamp_and_channel_id_and_type'
    add_index :conversation_messages, [:type, :channel_id, :timestamp], name: 'index_cm_on_type_and_channel_id_and_timestamp'
    add_index :conversation_messages, :message, type: :fulltext
    add_index :conversation_messages, :nick, type: :fulltext
    add_index :conversation_messages, [:message, :nick], type: :fulltext
  end
end
