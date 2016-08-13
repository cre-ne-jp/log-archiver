require 'test_helper'

class QuitTest < ActiveSupport::TestCase
  setup do
    @quit = create(:quit)
  end

  test '有効である' do
    assert(@quit.valid?)
  end

  test 'Tiarra のログ形式が正しい' do
    assert_equal('12:34:59 ! rgrb (Bye!)', @quit.to_tiarra_format)
  end
end
