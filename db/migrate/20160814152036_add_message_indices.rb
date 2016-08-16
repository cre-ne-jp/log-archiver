class AddMessageIndices < ActiveRecord::Migration
  def change
    add_index :messages, [:id, :timestamp]
    add_index :messages, [:id, :channel_id]
    add_index :messages, [:id, :channel_id, :timestamp]
  end
end
