# frozen_string_literal: true

class SetIrcUserId1ToDummy < ActiveRecord::Migration[5.2]
  DUMMY_USER = 'dummy'
  DUMMY_HOST = 'irc.example.net'

  # IRCユーザーの1番をダミーユーザーに設定し、
  # ConversationMessages#irc_user が nil にならないようにする
  # nil になるのは不整合であるため
  #
  # Tiarraログファイルからログを取り込んだ場合、
  # ホスト名の情報が含まれておらず、対応するIRCユーザーが設定されない
  #
  # TODO: 根本的にはテーブルを分割し、
  # ConversationMessage-IrcUser
  # の対応を表せるようにしなければならない
  def up
    first_irc_user = IrcUser.find_by(id: 1)

    if first_irc_user.nil?
      create_dummy_irc_user
    elsif first_irc_user.user == DUMMY_USER && first_irc_user.host == DUMMY_HOST
      puts
      puts('ダミーのIRCユーザーが既に設定されています')

      update_message_irc_user_id_from_null_to_1
    else
      duplicated_first_irc_user = duplicate_first_irc_user(first_irc_user)
      create_dummy_user_as_id_1(first_irc_user)

      update_message_irc_user_id_from_1_to(duplicated_first_irc_user)
      update_conversation_message_irc_user_id_from_1_to(duplicated_first_irc_user)

      update_message_irc_user_id_from_null_to_1
    end

    puts
    puts('[conversation_messages.irc_user_id の退避]')
    id_irc_user_id_pairs = {}
    ConversationMessage.where.not(irc_user_id: 0).find_each do |cm|
      id_irc_user_id_pairs[cm.irc_user_id] ||= []
      id_irc_user_id_pairs[cm.irc_user_id] << cm.id
    end

    n_irc_user_ids = id_irc_user_id_pairs.length
    n_conversation_messages = id_irc_user_id_pairs.values.map(&:length).sum
    puts("#{n_irc_user_ids} 名（#{n_conversation_messages} 件）の irc_user_id を退避")

    puts
    puts('[テーブルの変更]')
    change_column :messages, :irc_user_id, :integer, null: false, default: 1
    change_table :conversation_messages do |t|
      t.remove :irc_user_id
      t.integer :irc_user_id, null: false, default: 1
    end

    puts
    puts('[conversation_messages.irc_user_id の復元]')
    id_irc_user_id_pairs.each do |irc_user_id, cm_ids|
      n = ConversationMessage.where(id: cm_ids).update_all(irc_user_id: irc_user_id)
      puts("IRCユーザーID #{irc_user_id}: #{n} 件復元")
    end
  end

  def down
  end

  private

  # ダミーのIRCユーザーを作る
  # @return [IrcUser] ダミーのIRCユーザー
  def create_dummy_irc_user
    puts
    puts('[ダミーのIRCユーザーの作成]')
    dummy_user = IrcUser.new(id: 1, user: DUMMY_USER, host: DUMMY_HOST)
    dummy_user.save!
    puts("ダミーのIRCユーザー: ユーザー名 = #{dummy_user.user}, ホスト = #{dummy_user.host}")

    dummy_user
  end

  # 最初のIRCユーザーをコピーする
  # @param [IrcUser] first_irc_user 最初のIRCユーザー
  # @return [IrcUser] コピーされた最初のIRCユーザー
  def duplicate_first_irc_user(first_irc_user)
    puts
    puts('[最初のIRCユーザーの情報のコピー]')
    duplicated_first_irc_user = first_irc_user.dup
    duplicated_first_irc_user.id = nil
    duplicated_first_irc_user.created_at = first_irc_user.created_at
    duplicated_first_irc_user.save!
    puts("最初のIRCユーザー -> id = #{duplicated_first_irc_user.id}, ユーザー名 = #{duplicated_first_irc_user.user}, ホスト = #{duplicated_first_irc_user.host}")

    duplicated_first_irc_user
  end

  # ダミーのIRCユーザーをID 1として作る
  # @param [IrcUser] first_irc_user 最初のIRCユーザー
  # @return [IrcUser] ダミーのIRCユーザー
  def create_dummy_user_as_id_1(first_irc_user)
    puts
    puts('[ダミーのIRCユーザーをIRCユーザーID: 1として設定]')
    dummy_user = first_irc_user
    dummy_user.user = DUMMY_USER
    dummy_user.host = DUMMY_HOST
    dummy_user.save!
    puts("ダミーのIRCユーザー -> id = #{dummy_user.id}, ユーザー名 = #{dummy_user.user}, ホスト = #{dummy_user.host}")

    dummy_user
  end

  # Message.irc_user_idをNULLから1に更新する
  # @return [void]
  def update_message_irc_user_id_from_null_to_1
    puts
    puts('[Message.irc_user_id: NULL を解消して 1 に設定する]')
    n_message_null_updated = Message.
      where(irc_user_id: nil).
      update_all(irc_user_id: 1)
    puts("Message.irc_user_id: #{n_message_null_updated} 件の NULL を解消")
  end

  # Message.irc_user_idを1からコピーされた最初のIRCユーザーのIDに更新する
  # @param [IrcUser] duplicated_first_irc_user コピーされた最初のIRCユーザー
  # @return [void]
  def update_message_irc_user_id_from_1_to(duplicated_first_irc_user)
    puts
    puts('[Message.irc_user_id: 1 からコピーされた最初のIRCユーザーのIDに更新する]')
    n_message_updated = Message.
      where(irc_user_id: 1).
      update_all(irc_user_id: duplicated_first_irc_user.id)
    puts("Message.irc_user_id: #{n_message_updated} 件更新")
  end

  # ConversationMessage.irc_user_idを1からコピーされた最初のIRCユーザーのIDに更新する
  # @param [IrcUser] duplicated_first_irc_user コピーされた最初のIRCユーザー
  # @return [void]
  def update_conversation_message_irc_user_id_from_1_to(duplicated_first_irc_user)
    puts
    puts('[ConversationMessage.irc_user_id: 1 からコピーされた最初のIRCユーザーのIDに更新する]')
    n_conversation_message_updated = ConversationMessage.
      where(irc_user_id: 1).
      update_all(irc_user_id: duplicated_first_irc_user.id)
    puts("ConversationMessage.irc_user_id: #{n_conversation_message_updated} 件更新")
  end
end
