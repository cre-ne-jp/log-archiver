FactoryBot.define do
  factory :message_period do
    channels { [create(:channel).identifier] }
    since { Time.zone.local(2001, 2, 3, 4, 56, 7) }

    # until はRubyの予約語なので、add_attribute で追加する
    add_attribute(:until) { Time.zone.local(2002, 3, 4, 5, 43, 21) }
  end
end
