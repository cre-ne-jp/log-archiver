# frozen_string_literal: true

class ArchiveReason < ApplicationRecord
  has_many :archive_conversation_messages

  validates :reason, presence: true
end
