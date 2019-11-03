FactoryBot.define do
  factory :archive_reason do
    reason { '個人情報' }

    initialize_with {
      ArchiveReason.find_or_initialize_by(reason: reason) do |new_reason|
        new_reason.attributes = attributes
      end
    }
  end
end
