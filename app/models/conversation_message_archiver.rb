# frozen_string_literal: true

# ConversationMessage と ArchivedConversationMessage の間で、
# 非表示にするメッセージを相互に遣り取りするモデル
class ConversationMessageArchiver
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  # ConversationMessage -> Archived
  # @param [ActionController::Parameter] params フォームヘルパーが送信するパラメーター
  # @option [String] :old_id 元の ConversationMessage.id
  # @option [String] :archive_reason 非表示理由
  # @return [ArchivedConversationMessage]
  def archive!(params)
    old_id = params[:old_id]
    unless cm = ConversationMessage.find(old_id)
      raise(ArgumentError, 'old_id is required.')
    end
    archive_reason = params[:archive_reason_id]
    unless reason = ArchiveReason.find(archive_reason)
      raise(ArgumentError, 'archive_reason is required.')
    end

    am = ArchivedConversationMessage.from_conversation_message(cm)
    am.archive_reason = reason

    # Mroonga ストレージモードはトランザクション非対応
    ApplicationRecord.transaction do
      am.save!
      cm.destroy!
    end

    am
  end

  # Archived -> ConversationMessage
  # @param [ActionController::Parameter] params フォームヘルパーが送信するパラメーター
  # @option [String] :id 元の ArchivedConversationMessage.old_id
  # @return [ConversationMessage]
  def reconstitute!(params)
    old_id = params[:id]
    unless am = ArchivedConversationMessage.find_by(old_id: params[:id])
      raise(ArgumentError, 'old_id is required.')
    end

    cm = ConversationMessage.new
    cm.attributes = {
      id: am.old_id,
      channel_id: am.channel_id,
      timestamp: am.timestamp,
      nick: am.nick,
      message: am.message,
      type: am.type,
      irc_user_id: am.irc_user_id,
      digest: am.digest,
      created_at: am.created_at
    }

    # Mroonga ストレージモードはトランザクション非対応
    ApplicationRecord.transaction do
      cm.save!
      am.destroy!
    end

    cm
  end
end
