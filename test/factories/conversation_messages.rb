FactoryGirl.define do
  factory :conversation_message do
    channel nil
    irc_user nil
    type 1
    timestamp "2016-11-29 00:42:49"
    nick "MyString"
    message "MyText"
  end
end
