class CreateConversationMessages < ActiveRecord::Migration
  def change
    create_table :conversation_messages, options: 'ENGINE=Mroonga' do |t|
      t.references :channel, index: true, foreign_key: true
      t.references :irc_user, index: true, foreign_key: true
      t.integer :command, null: false, default: 0
      t.datetime :timestamp, null: false
      t.string :nick, limit: 64, default: '', null: false
      t.text :message

      t.timestamps null: false
    end
  end
end
