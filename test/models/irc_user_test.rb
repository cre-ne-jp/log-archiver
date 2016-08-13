require 'test_helper'

class IrcUserTest < ActiveSupport::TestCase
  setup do
    @user = create(:irc_user)
  end

  test '有効である' do
    assert(@user.valid?)
  end
end
