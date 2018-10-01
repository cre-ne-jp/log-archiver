class RecreateIrcUsers < ActiveRecord::Migration[4.2]
  def change
    drop_table :irc_users

    create_table "irc_users", options: 'ENGINE=Mroonga' do |t|
      t.string   "user",       limit: 64,  default: "", null: false
      t.string   "host",       limit: 255, default: "", null: false
    end
  end
end
