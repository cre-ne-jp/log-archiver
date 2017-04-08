FactoryGirl.define do
  factory :channel_browse do
    channel { create(:channel).identifier }
    date_type :specify
    date Date.new(2017, 1, 23)
  end
end
