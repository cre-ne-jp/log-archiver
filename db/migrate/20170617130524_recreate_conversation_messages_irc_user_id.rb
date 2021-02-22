class RecreateConversationMessagesIrcUserId < ActiveRecord::Migration[4.2]
  def up
    @print_phase_separate = false

    print_phase('irc_user_id の退避')
    id_irc_user_id_pairs = {}
    ConversationMessage.where.not(irc_user_id: 0).find_each do |cm|
      id_irc_user_id_pairs[cm.irc_user_id] ||= []
      id_irc_user_id_pairs[cm.irc_user_id] << cm.id
    end

    print_phase('テーブルの変更')
    change_table :conversation_messages do |t|
      t.remove :irc_user_id
      t.integer :irc_user_id, null: false, default: 0
    end

    print_phase('irc_user_id の復元')
    id_irc_user_id_pairs.each do |irc_user_id, cm_ids|
      ConversationMessage.where(id: cm_ids).update_all(irc_user_id: irc_user_id)
    end

    print_phase('irc_user_id のインデックスの再構築')
    add_index :conversation_messages, :irc_user_id
  end

  def down
  end

  private

  # 進捗表示：段階を表示する
  def print_phase(name)
    puts if @print_phase_separate
    puts("[#{name}]")

    @print_phase_separate = true
  end
end
