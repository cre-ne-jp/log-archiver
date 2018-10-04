FactoryBot.define do
  factory :channel_browse_year, class: ChannelBrowse::Year do
    channel
    year { 2017 }
  end
end
