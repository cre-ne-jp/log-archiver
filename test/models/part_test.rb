require 'test_helper'
require 'models/test_helper_for_to_hash_for_json'

class PartTest < ActiveSupport::TestCase
  include TestHelperForToHashForJson

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

  test 'to_hash_for_json: 値が正しく設定される' do
    hash = @part.to_hash_for_json
    assert_contain_valid_message_data(@part, hash, 'Part')
  end
end
