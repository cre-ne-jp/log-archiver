class AddIndexForTypeToConversationMessages < ActiveRecord::Migration[4.2]
  def change
    add_index :conversation_messages, :type
  end
end
