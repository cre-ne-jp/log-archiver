require 'test_helper'
require 'models/test_helper_for_to_hash_for_json'

class KickTest < ActiveSupport::TestCase
  include TestHelperForToHashForJson

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
    assert_contain_valid_message_data(@kick, hash, 'Kick')
  end
end
