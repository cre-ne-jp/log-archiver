class ResetLimitOfIrcUserName < ActiveRecord::Migration
  def change
    change_column :irc_users, :name, :string, limit: 64, null: false, default: ''
  end
end
