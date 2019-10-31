# frozen_string_literal: true

# ConversationMessage と ArchivedConversationMessage の間で、
# 非表示にするメッセージを相互に遣り取りするモデル
class ConversationMessageArchiver
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  # ConversationMessage -> Archived
  # @param [ActionController::Parameter] params フォームヘルパーが送信するパラメーター
  # @option [String] :archive_reason 非表示理由
  # @option [String] :old_id ConversationMessage.id
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

    am = ArchivedConversationMessage.new.attribute_by_conversation_message(cm)
    am.archive_reason = reason

    # Mroonga ストレージモードはトランザクション非対応
    ApplicationRecord.transaction do
      am.save!
      cm.destroy!
    end

    am
  end

  # Archived -> ConversationMessage
  # @param [ArchivedConversationMessage] m 再表示するメッセージ
  # @return [ConversationMessage]
  def reconstituter(m)
  end
end
