FactoryGirl.define do
  factory :user do
    username 'test_user'
    email ''
    password 'pa$$word'
    password_confirmation 'pa$$word'

    initialize_with { User.find_or_create_by(username: username) }
  end
end
