class RenameIrcUserNameToIrcUserUser < ActiveRecord::Migration[4.2]
  def change
    rename_column :irc_users, :name, :user
  end
end
