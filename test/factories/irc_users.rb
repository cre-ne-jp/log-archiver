FactoryBot.define do
  factory :irc_user do
    user { 'rgrb_bot' }
    host { 'irc.cre.jp' }

    initialize_with {
      IrcUser.find_or_initialize_by(user: user, host: host)
    }

    factory :irc_user_role do
      user { 'Role' }
      host { 'irc.trpg.net' }
    end

    factory :irc_user_toybox do
      user { 'Toybox' }
    end
  end
end
