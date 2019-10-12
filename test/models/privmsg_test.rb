require 'test_helper'
require 'models/test_helper_for_to_hash_for_json'

class PrivmsgTest < ActiveSupport::TestCase
  include TestHelperForToHashForJson

  setup do
    @privmsg = create(:privmsg)
  end

  test '有効である' do
    assert(@privmsg.valid?)
  end

  test 'message は必須' do
    @privmsg.message = nil
    refute(@privmsg.valid?, 'nilは無効')

    @privmsg.message = ''
    refute(@privmsg.valid?, '空文字列は無効')
  end

  test 'message は空白のみでもよい' do
    @privmsg.message = ' 　' * 10
    assert(@privmsg.valid?)
  end

  test 'Tiarra のログ形式が正しい' do
    assert_equal('12:35:03 <#irc_test:rgrb> プライベートメッセージ',
                 @privmsg.to_tiarra_format)
  end

  test 'to_hash_for_json: 値が正しく設定される' do
    hash = @privmsg.to_hash_for_json
    assert_contain_valid_conversation_message_data(@privmsg, hash, 'Privmsg')
  end
end
