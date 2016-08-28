class CreateIrcUsers < ActiveRecord::Migration
  def change
    create_table :irc_users do |t|
      t.string :name, limit: 9, null: false, default: ''
      t.string :host, null: false, default: ''

      t.timestamps null: false
    end
  end
end
