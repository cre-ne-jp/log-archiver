class AddIndexForTypeToConversationMessages < ActiveRecord::Migration
  def change
    add_index :conversation_messages, :type

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
