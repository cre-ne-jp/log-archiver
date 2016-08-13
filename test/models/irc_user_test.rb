require 'test_helper'

class IrcUserTest < ActiveSupport::TestCase
  setup do
    @user = create(:irc_user)
  end

  test '有効である' do
    assert(@user.valid?)
  end

  test 'name は 16 文字以下' do
    @user.name = 'a' * 16
    assert(@user.valid?, '16 文字は OK')

    @user.name = 'a' * 17
    refute(@user.valid?, '17 文字は NG')
  end

  test 'マスクの形式が正しい' do
    assert_equal('rgrb!rgrb_bot@irc.cre.jp', @user.mask('rgrb'))
  end
end
