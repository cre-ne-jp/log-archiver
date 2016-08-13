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
end
