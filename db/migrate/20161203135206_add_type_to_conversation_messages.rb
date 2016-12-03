class AddTypeToConversationMessages < ActiveRecord::Migration
  def up
    remove_column :conversation_messages, :command
    add_column :conversation_messages, :type, :string
  end

  def down
    remove_column :conversation_messages, :type
    add_column :conversation_messages, :command, :integer
  end
end
