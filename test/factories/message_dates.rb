FactoryGirl.define do
  factory :message_date do
    channel
    date '2016-08-16'

    initialize_with {
      MessageDate.find_or_create_by(channel: channel, date: date)
    }

    factory :message_date_20161231 do
      date '2016-12-31'
    end

    factory :message_date_20170401 do
      date '2017-04-01'
    end
  end
end
