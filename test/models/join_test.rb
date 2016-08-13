require 'test_helper'

class JoinTest < ActiveSupport::TestCase
  setup do
    @join = create(:join)
  end

  test '有効である' do
    assert(@join.valid?)
  end
end
