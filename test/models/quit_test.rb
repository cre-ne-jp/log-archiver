require 'test_helper'
require 'models/test_helper_for_to_hash_for_json'

class QuitTest < ActiveSupport::TestCase
  include TestHelperForToHashForJson

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
    assert_contain_valid_message_data(@quit, hash, 'Quit')
  end
end
