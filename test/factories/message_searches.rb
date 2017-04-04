FactoryGirl.define do
  factory :message_search do
    query 'test'
    nick 'someone'
    channels { [create(:channel).identifier] }
    since Date.new(2001, 2, 3)
    add_attribute(:until) { nil }
  end
end
