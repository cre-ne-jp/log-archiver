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
end
