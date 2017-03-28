class AddIndicesToCovnersationMessages < ActiveRecord::Migration
  def change
    add_index :conversation_messages, :command
    add_index :conversation_messages, :nick
    add_index :conversation_messages, :timestamp
    add_index :conversation_messages, [:id, :channel_id, :timestamp]
    add_index :conversation_messages, [:id, :channel_id]
    add_index :conversation_messages, [:id, :timestamp]

    add_index :conversation_messages, :message, type: :fulltext

    reversible do |dir|
      dir.up do
        execute('ALTER TABLE conversation_messages DISABLE KEYS')
        execute('ALTER TABLE conversation_messages ENABLE KEYS')
      end

      dir.down do
      end
    end
  end
end
