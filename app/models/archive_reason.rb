# frozen_string_literal: true

class ArchiveReason < ApplicationRecord
  has_many :archived_conversation_messages

  validates :reason, presence: true
end
