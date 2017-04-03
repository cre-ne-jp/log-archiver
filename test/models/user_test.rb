require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
  end

  test '有効である' do
    assert(@user.valid?)
  end

  test 'username は必須' do
    @user.username = nil
    refute(@user.valid?, 'nil は無効')

    @user.username = ''
    refute(@user.valid?, '空文字列は無効')
  end

  test 'username は空白のみではならない' do
    @user.username = ' ' * 10
    refute(@user.valid?)
  end

  test 'username は 255 文字以下' do
    @user.username = 'a' * 256
    refute(@user.valid?)
  end

  test '同一の username は無効' do
    user2 = User.new
    user2.username = @user.username
    user2.password_confirmation = user2.password = 'a' * 8

    refute(user2.valid?)
  end

  test '新規作成時、password は必須' do
    user2 = User.new
    user2.username = 'user2'
    user2.password_confirmation = user2.password = nil

    refute(user2.valid?)
  end

  test 'password は 4 文字以上 255 文字以下' do
    @user.password_confirmation = @user.password = 'a' * 3
    refute(@user.valid?, '3 文字は無効')

    @user.password_confirmation = @user.password = 'a' * 4
    assert(@user.valid?, '4 文字は有効')

    @user.password_confirmation = @user.password = 'a' * 255
    assert(@user.valid?, '255 文字は有効')

    @user.password_confirmation = @user.password = 'a' * 256
    refute(@user.valid?, '256 文字は無効')
  end

  test 'password と確認が一致しなければならない' do
    @user.password = 'a' * 8
    @user.password_confirmation = 'a' * 7
    refute(@user.valid?)
  end
end
