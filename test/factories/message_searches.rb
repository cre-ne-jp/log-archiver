FactoryGirl.define do
  factory :message_search do
    query 'test'
    channel { create(:channel).identifier }
    since nil
    add_attribute(:until) { nil }
  end
end
