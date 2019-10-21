class AddColumnFragment < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :fragment, :string, null: false, default: ''
    add_column :conversation_messages, :fragment, :string, null: false, default: ''
  end
end
