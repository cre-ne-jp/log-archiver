require 'test_helper'

class JoinTest < ActiveSupport::TestCase
  setup do
    @join = create(:join)
  end

  test '有効である' do
    assert(@join.valid?)
  end

  test 'Tiarra のログ形式が正しい' do
    assert_equal('12:34:57 + rgrb (rgrb!rgrb_bot@irc.cre.jp) to #irc_test',
                 @join.to_tiarra_format)
  end

  test 'to_hash_for_json: 値が正しく設定される' do
    hash = @join.to_hash_for_json

    assert_equal(@join.id, hash['id'])
    assert_equal(@join.channel_id, hash['channel_id'])
    assert_equal(@join.irc_user_id, hash['irc_user_id'])
    assert_equal('Join', hash['type'])
    assert_equal(@join.timestamp, Time.parse(hash['timestamp']))
    assert_equal(@join.nick, hash['nick'])
    assert_equal(@join.message, hash['message'])
    assert_equal(@join.target, hash['target'])
    assert_equal(@join.created_at, Time.parse(hash['created_at']))
    assert_equal(@join.updated_at, Time.parse(hash['updated_at']))
  end
end
