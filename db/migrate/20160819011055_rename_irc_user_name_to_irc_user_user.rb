class RenameIrcUserNameToIrcUserUser < ActiveRecord::Migration
  def change
    rename_column :irc_users, :name, :user
  end
end
