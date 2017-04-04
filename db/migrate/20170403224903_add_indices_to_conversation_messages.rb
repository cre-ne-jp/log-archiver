class AddIndicesToConversationMessages < ActiveRecord::Migration
  reversible do |dir|
    dir.up do
      remove_index :conversation_messages, column: :nick

      add_index :conversation_messages, :nick, type: :fulltext
      add_index :conversation_messages, [:nick, :message], type: :fulltext
      add_index :conversation_messages, [:channel_id, :timestamp]

      execute('ALTER TABLE conversation_messages DISABLE KEYS')
      execute('ALTER TABLE conversation_messages ENABLE KEYS')
    end

    dir.down do
      add_index :conversation_messages, :nick

      remove_index :conversation_messages, column: :nick
      remove_index :conversation_messages, column: [:nick, :message]
      remove_index :conversation_messages, column: [:channel_id, :timestamp]

      execute('ALTER TABLE conversation_messages DISABLE KEYS')
      execute('ALTER TABLE conversation_messages ENABLE KEYS')
    end
  end
end
