class CreateArchivedConversationMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :archived_conversation_messages, options: 'ENGINE=Mroonga' do |t|
      t.integer :old_id, default: 0, null: false
      t.integer :channel_id
      t.datetime :timestamp, null: false
      t.string :nick, limit: 64, default: '', null: false
      t.text :message
      t.string :type, null: false
      t.integer :irc_user_id, default: 1, null: false
      t.string :digest, default: '', null: false
      t.integer :archive_reason_id, default: 0, null: false

      t.timestamps
    end

    create_table :archive_reasons do |t|
      t.string :reason, default: '', null: false

      t.timestamps
    end
  end
end
