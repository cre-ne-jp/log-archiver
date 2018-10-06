class ResetLimitOfIrcUserName < ActiveRecord::Migration[4.2]
  def change
    change_column :irc_users, :name, :string, limit: 64, null: false, default: ''
  end
end
