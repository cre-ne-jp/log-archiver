FactoryGirl.define do
  factory :channel_browse_day, class: ChannelBrowse::Day do
    channel
    date Date.new(2017, 1, 23)
    style :normal
  end
end
