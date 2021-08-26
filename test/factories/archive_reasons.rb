FactoryBot.define do
  factory :archive_reason do
    reason { '利用規約に違反しているため' }

    initialize_with {
      ArchiveReason.find_or_initialize_by(reason: reason) do |new_reason|
        new_reason.attributes = attributes
      end
    }
  end
end
