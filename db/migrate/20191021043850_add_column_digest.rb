class AddColumnDigest < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :digest, :string, null: false, default: ''
    add_column :conversation_messages, :digest, :string, null: false, default: ''
  end
end
