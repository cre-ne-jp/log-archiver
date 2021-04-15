FactoryBot.define do
  factory :user do
    username { 'test_user' }
    email { '' }
    password { 'pa$$word' }
    password_confirmation { 'pa$$word' }

    initialize_with {
      User.find_or_initialize_by(username: username) do |new_user|
        new_user.attributes = attributes
      end
    }
  end
end
