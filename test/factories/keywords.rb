FactoryBot.define do
  factory :keyword do
    display_title { 'Sword World 2.0' }
    title { Keyword.normalize(display_title) }

    initialize_with {
      Keyword.find_or_initialize_by(title: title) do |new_keyword|
        new_keyword.attributes = attributes
      end
    }
  end
end
