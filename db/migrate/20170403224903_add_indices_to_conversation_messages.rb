class AddIndicesToConversationMessages < ActiveRecord::Migration[4.2]
  def change
    remove_index :conversation_messages, column: :nick

    add_index :conversation_messages, :nick, type: :fulltext
    add_index :conversation_messages, [:nick, :message], type: :fulltext
    add_index :conversation_messages, [:channel_id, :timestamp]
  end
end
