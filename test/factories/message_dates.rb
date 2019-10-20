FactoryBot.define do
  factory :message_date do
    channel
    date { '2016-08-16' }

    initialize_with {
      MessageDate.find_or_initialize_by(channel: channel, date: date)
    }

    factory :message_date_20150123 do
      date { '2015-01-23' }
    end

    factory :message_date_20161231 do
      date { '2016-12-31' }
    end

    factory :message_date_20170401 do
      date { '2017-04-01' }
    end

    factory :message_date_20170402 do
      date { '2017-04-02' }
    end
  end
end
