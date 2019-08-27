require 'test_helper'

class NickTest < ActiveSupport::TestCase
  setup do
    @nick = create(:nick)
  end

  test '有効である' do
    assert(@nick.valid?)
  end

  test 'message は必須' do
    @nick.message = nil
    refute(@nick.valid?)
  end

  test 'message は空白のみではならない' do
    @nick.message = ' ' * 10
    refute(@nick.valid?)
  end

  test 'new_nick は新しいニックネームを返す' do
    assert_equal(@nick.new_nick, @nick.message)
  end

  test 'new_nick に代入できる' do
    @nick.new_nick = 'rgrb3'
    assert_equal('rgrb3', @nick.message)
  end

  test 'Tiarra のログ形式が正しい' do
    assert_equal('12:35:01 rgrb -> rgrb2', @nick.to_tiarra_format)
  end

  test 'to_hash_for_json: 値が正しく設定される' do
    hash = @nick.to_hash_for_json

    assert_equal(@nick.id, hash['id'])
    assert_equal(@nick.channel_id, hash['channel_id'])
    assert_equal(@nick.irc_user_id, hash['irc_user_id'])
    assert_equal('Nick', hash['type'])
    assert_equal(@nick.timestamp, Time.parse(hash['timestamp']))
    assert_equal(@nick.nick, hash['nick'])
    assert_equal(@nick.message, hash['message'])
    assert_equal(@nick.target, hash['target'])
    assert_equal(@nick.created_at, Time.parse(hash['created_at']))
    assert_equal(@nick.updated_at, Time.parse(hash['updated_at']))
  end
end
