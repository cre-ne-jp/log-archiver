class AddIndicesToConversationMessages20190901 < ActiveRecord::Migration[5.2]
  def change
    remove_index(:conversation_messages,
                 column: [:timestamp, :channel_id, :type],
                 name: 'index_cm_on_timestamp_and_channel_id_and_type')

    add_index :conversation_messages, [:timestamp, :channel_id]
  end
end
