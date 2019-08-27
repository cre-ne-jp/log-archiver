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

    assert_equal(@privmsg.id, hash['id'])
    assert_equal(@privmsg.channel_id, hash['channel_id'])
    assert_equal(@privmsg.timestamp, Time.parse(hash['timestamp']))
    assert_equal(@privmsg.nick, hash['nick'])
    assert_equal(@privmsg.message, hash['message'])
    assert_equal(@privmsg.created_at, Time.parse(hash['created_at']))
    assert_equal(@privmsg.updated_at, Time.parse(hash['updated_at']))
    assert_equal('Privmsg', hash['type'])
    assert_equal(@privmsg.irc_user_id, hash['irc_user_id'])
  end
end
