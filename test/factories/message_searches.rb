FactoryBot.define do
  factory :message_search do
    query { 'test' }
    nick { 'someone' }
    channels { [create(:channel).identifier] }
    since { Date.new(2001, 2, 3) }

    # until はRubyの予約語なので、add_attribute で追加する
    add_attribute(:until) { Date.new(2002, 3, 4) }

    page { 2 }
  end
end
