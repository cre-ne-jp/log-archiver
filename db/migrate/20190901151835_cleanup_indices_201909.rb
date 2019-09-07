class CleanupIndices201909 < ActiveRecord::Migration[5.2]
  def change
    remove_index :messages, column: :channel_id
    remove_index :messages, column: [:id, :channel_id, :timestamp]
    remove_index :messages, column: [:id, :channel_id]
    remove_index :messages, column: [:id, :timestamp]
    remove_index :messages, column: :irc_user_id
    remove_index :messages, column: :nick
    remove_index :messages, column: :timestamp
    remove_index :messages, column: :type

    add_index :messages, [:timestamp, :channel_id]
  end
end
