class DropForeignKeyFromConversationMessagesToIrcUsersIfExists < ActiveRecord::Migration[5.2]
  def up
    unless foreign_key_exists?(:conversation_messages, :irc_users)
      puts('conversation_messages -> irc_users の外部キー制約は存在しません')
      return
    end

    remove_foreign_key(:conversation_messages, :irc_users)
  end

  def down
    # 何もしない
  end
end
