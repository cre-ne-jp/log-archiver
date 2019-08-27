require 'test_helper'

class NoticeTest < ActiveSupport::TestCase
  setup do
    @notice = create(:notice)
  end

  test '有効である' do
    assert(@notice.valid?)
  end

  test 'message は必須' do
    @notice.message = nil
    refute(@notice.valid?, 'nilは無効')

    @notice.message = ''
    refute(@notice.valid?, '空文字列は無効')
  end

  test 'message は空白のみでもよい' do
    @notice.message = ' 　' * 10
    assert(@notice.valid?)
  end

  test 'Tiarra のログ形式が正しい' do
    assert_equal('12:35:04 (#irc_test:rgrb) 通知',
                 @notice.to_tiarra_format)
  end

  test 'to_hash_for_json: 値が正しく設定される' do
    hash = @notice.to_hash_for_json

    assert_equal(@notice.id, hash['id'])
    assert_equal(@notice.channel_id, hash['channel_id'])
    assert_equal(@notice.timestamp, Time.parse(hash['timestamp']))
    assert_equal(@notice.nick, hash['nick'])
    assert_equal(@notice.message, hash['message'])
    assert_equal(@notice.created_at, Time.parse(hash['created_at']))
    assert_equal(@notice.updated_at, Time.parse(hash['created_at']))
    assert_equal('Notice', hash['type'])
    assert_equal(@notice.irc_user_id, hash['irc_user_id'])
  end
end
