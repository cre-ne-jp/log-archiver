class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :channel, index: true, foreign_key: true
      t.references :irc_user, index: true, foreign_key: true
      t.string :type
      t.timestamp :timestamp, null: false
      t.string :nick, limit: 64, null: false, default: ''
      t.text :message
      t.string :target, limit: 64

      t.timestamps null: false
    end
    add_index :messages, :type
    add_index :messages, :timestamp
    add_index :messages, :nick
  end
end
