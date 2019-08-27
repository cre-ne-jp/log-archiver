require 'test_helper'

class QuitTest < ActiveSupport::TestCase
  setup do
    @quit = create(:quit)
  end

  test '有効である' do
    assert(@quit.valid?)
  end

  test 'Tiarra のログ形式が正しい' do
    assert_equal('12:34:59 ! rgrb (Bye!)', @quit.to_tiarra_format)
  end

  test 'to_hash_for_json: 値が正しく設定される' do
    hash = @quit.to_hash_for_json

    assert_equal(@quit.id, hash['id'])
    assert_equal(@quit.channel_id, hash['channel_id'])
    assert_equal(@quit.irc_user_id, hash['irc_user_id'])
    assert_equal('Quit', hash['type'])
    assert_equal(@quit.timestamp, Time.parse(hash['timestamp']))
    assert_equal(@quit.nick, hash['nick'])
    assert_equal(@quit.message, hash['message'])
    assert_equal(@quit.target, hash['target'])
    assert_equal(@quit.created_at, Time.parse(hash['created_at']))
    assert_equal(@quit.updated_at, Time.parse(hash['updated_at']))
  end
end
