require 'test_helper'

class KickTest < ActiveSupport::TestCase
  setup do
    @kick = create(:kick)
  end

  test '有効である' do
    assert(@kick.valid?)
  end

  test 'target は必須' do
    @kick.target = nil
    refute(@kick.valid?)
  end

  test 'target は空白のみではならない' do
    @kick.target = ' ' * 10
    refute(@kick.valid?)
  end

  test 'Tiarra のログ形式が正しい' do
    assert_equal('12:35:00 - rgrb by ocha from #irc_test (暴走したので KICK)',
                 @kick.to_tiarra_format)
  end

  test 'to_hash_for_json: 値が正しく設定される' do
    hash = @kick.to_hash_for_json

    assert_equal(@kick.id, hash['id'])
    assert_equal(@kick.channel_id, hash['channel_id'])
    assert_equal(@kick.irc_user_id, hash['irc_user_id'])
    assert_equal('Kick', hash['type'])
    assert_equal(@kick.timestamp, Time.parse(hash['timestamp']))
    assert_equal(@kick.nick, hash['nick'])
    assert_equal(@kick.message, hash['message'])
    assert_equal(@kick.target, hash['target'])
    assert_equal(@kick.created_at, Time.parse(hash['created_at']))
    assert_equal(@kick.updated_at, Time.parse(hash['updated_at']))
  end
end
