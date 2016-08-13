require 'test_helper'

class PrivmsgTest < ActiveSupport::TestCase
  setup do
    @privmsg = create(:privmsg)
  end

  test '有効である' do
    assert(@privmsg.valid?)
  end

  test 'message は必須' do
    @privmsg.message = nil
    refute(@privmsg.valid?)
  end

  test 'message は空白のみではならない' do
    @privmsg.message = ' ' * 10
    refute(@privmsg.valid?)
  end

  test 'Tiarra のログ形式が正しい' do
    assert_equal('12:35:03 <#irc_test:rgrb> プライベートメッセージ',
                 @privmsg.to_tiarra_format)
  end
end
