require 'test_helper'

class PartTest < ActiveSupport::TestCase
  setup do
    @part = create(:part)
  end

  test '有効である' do
    assert(@part.valid?)
  end

  test 'Tiarra のログ形式が正しい：メッセージなし' do
    @part.message = ''
    assert_equal('12:34:58 - rgrb from #irc_test', @part.to_tiarra_format)
  end

  test 'Tiarra のログ形式が正しい：メッセージあり' do
    assert_equal('12:34:58 - rgrb from #irc_test (Bye!)',
                 @part.to_tiarra_format)
  end
end
