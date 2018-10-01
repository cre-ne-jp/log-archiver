class AddMessageIndices < ActiveRecord::Migration[4.2]
  def change
    add_index :messages, [:id, :timestamp]
    add_index :messages, [:id, :channel_id]
    add_index :messages, [:id, :channel_id, :timestamp]
  end
end
