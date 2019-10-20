FactoryBot.define do
  factory :keyword do
    title { 'sword_world_2.0' }
    display_title { 'Sword World 2.0' }

    initialize_with {
      Keyword.find_or_initialize_by(title: title) do |new_keyword|
        new_keyword.attributes = attributes
      end
    }
  end
end
