require 'test_helper'

class IrcUserTest < ActiveSupport::TestCase
  setup do
    @user = create(:irc_user)
  end

  test '有効である' do
    assert(@user.valid?)
  end

  test 'user は 64 文字以下' do
    @user.user = 'a' * 64
    assert(@user.valid?, '64 文字は OK')

    @user.user = 'a' * 65
    refute(@user.valid?, '65 文字は NG')
  end

  test 'マスクの形式が正しい' do
    assert_equal('rgrb!rgrb_bot@irc.cre.jp', @user.mask('rgrb'))
  end

  test 'ユーザー名とホストを含む文字列の形式が正しい' do
    assert_equal('rgrb_bot@irc.cre.jp', @user.user_host)
  end

  test 'to_hash_for_json: 値が正しく設定される' do
    hash = @user.to_hash_for_json

    assert_equal(@user.id, hash['id'])
    assert_equal(@user.user, hash['user'])
    assert_equal(@user.host, hash['host'])
    assert_equal(@user.created_at, Time.parse(hash['created_at']))
    assert_equal(@user.updated_at, Time.parse(hash['created_at']))
  end
end
