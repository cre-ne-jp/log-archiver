require 'test_helper'

class QuitTest < ActiveSupport::TestCase
  setup do
    @quit = create(:quit)
  end

  test '有効である' do
    assert(@quit.valid?)
  end
end
