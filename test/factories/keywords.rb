FactoryBot.define do
  factory :keyword do
    title { 'キーワードa_1' }
    display_title { 'キーワードA 1' }

    initialize_with { Keyword.find_or_create_by(title: title) }
  end
end
