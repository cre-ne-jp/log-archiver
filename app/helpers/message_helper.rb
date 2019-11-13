# frozen_string_literal: true

module MessageHelper
  def self.is_archived(type)
    ->m { m.kind_of?(ArchivedConversationMessage) && m.type == type }
  end

  IsArchived = {
    privmsg: is_archived('Privmsg'),
    notice: is_archived('Notice'),
    topic: is_archived('Topic')
  }

  PossibleArchiveTypes = %w(Privmsg Notice ArchivedConversationMessage).freeze

  # ConversationMessage の詳細ページのパスを返す
  # @param [ConversationMessage/Integer] cm
  # @return [String]
  # @return [nil]
  def admin_conversation_message_path(cm)
    unless cm.kind_of?(ConversationMessage)
      cm = ConversationMessage.find(cm)
    end

    params = {
      id: cm.channel.identifier,
      year: cm.timestamp.year,
      month: cm.timestamp.month,
      day: cm.timestamp.day,
      conversation_message_id: cm.id
    }

    admin_channels_conversation_message_path(params)
  end
end
