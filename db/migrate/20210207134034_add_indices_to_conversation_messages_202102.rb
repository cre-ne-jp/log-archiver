class AddIndicesToConversationMessages202102 < ActiveRecord::Migration[6.1]
  def change
    add_index :conversation_messages, [:channel_id, :timestamp, :id]
  end
end
