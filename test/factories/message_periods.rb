FactoryBot.define do
  factory :message_period do
    channels {
      %i(channel_100 channel_200).map { |c| create(c).identifier }
    }

    since { Time.new(2001, 2, 3, 4, 5, 6) }

    # until はRubyの予約語なので、add_attribute で追加する
    add_attribute(:until) { Time.new(2002, 3, 4, 12, 34, 56) }

    page { 2 }
  end
end
