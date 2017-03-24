FactoryGirl.define do
  factory :message_search do
    keyword 'test'
    channel { create(:channel).identifier }
    since nil
    add_attribute(:until) { nil }
  end
end
