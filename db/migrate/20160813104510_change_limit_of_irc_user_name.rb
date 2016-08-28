class ChangeLimitOfIrcUserName < ActiveRecord::Migration
  def change
    change_column :irc_users, :name, :string, limit: 16, null: false, default: ''
  end
end
