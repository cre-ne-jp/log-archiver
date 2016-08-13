require 'test_helper'

class IrcUserTest < ActiveSupport::TestCase
  setup do
    @user = create(:irc_user)
  end

  test '有効である' do
    assert(@user.valid?)
  end

  test 'マスクの形式が正しい' do
    assert_equal('rgrb!rgrb_bot@irc.cre.jp', @user.mask('rgrb'))
  end
end
