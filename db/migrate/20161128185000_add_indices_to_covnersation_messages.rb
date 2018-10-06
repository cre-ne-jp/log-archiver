class AddIndicesToCovnersationMessages < ActiveRecord::Migration[4.2]
  def change
    add_index :conversation_messages, :command
    add_index :conversation_messages, :nick
    add_index :conversation_messages, :timestamp
    add_index :conversation_messages, [:id, :channel_id, :timestamp]
    add_index :conversation_messages, [:id, :channel_id]
    add_index :conversation_messages, [:id, :timestamp]

    add_index :conversation_messages, :message, type: :fulltext
  end
end
