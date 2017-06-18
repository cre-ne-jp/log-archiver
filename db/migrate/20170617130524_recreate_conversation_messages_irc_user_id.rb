class RecreateConversationMessagesIrcUserId < ActiveRecord::Migration
  def up
    puts('[irc_user_id の退避]')
    id_irc_user_id_pairs = {}
    ConversationMessage.where.not(irc_user_id: 0).find_each do |cm|
      id_irc_user_id_pairs[cm.irc_user_id] ||= []
      id_irc_user_id_pairs[cm.irc_user_id] << cm.id
    end

    puts
    puts('[テーブルの変更]')
    change_table :conversation_messages do |t|
      t.remove :irc_user_id
      t.integer :irc_user_id, null: false, default: 0
    end

    puts
    puts('[irc_user_id の復元]')
    id_irc_user_id_pairs.each do |irc_user_id, cm_ids|
      ConversationMessage.where(id: cm_ids).update_all(irc_user_id: irc_user_id)
    end

    puts
    puts('[irc_user_id のインデックスの再構築]')
    add_index :conversation_messages, :irc_user_id
  end

  def down
  end
end
