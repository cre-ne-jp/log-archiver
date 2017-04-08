class AddIndexForTypeToConversationMessages < ActiveRecord::Migration
  def change
    add_index :conversation_messages, :type
  end
end
