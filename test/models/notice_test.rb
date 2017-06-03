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
end
