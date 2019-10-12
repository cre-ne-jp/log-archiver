require 'test_helper'
require 'models/test_helper_for_to_hash_for_json'

class JoinTest < ActiveSupport::TestCase
  include TestHelperForToHashForJson

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
    assert_contain_valid_message_data(@join, hash, 'Join')
  end
end
