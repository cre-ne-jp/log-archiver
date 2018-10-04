FactoryBot.define do
  factory :channel_browse_month, class: ChannelBrowse::Month do
    channel
    year { 2017 }
    month { 2 }
  end
end
