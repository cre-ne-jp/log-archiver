require 'test_helper'

class PartTest < ActiveSupport::TestCase
  setup do
    @part = create(:part)
  end

  test '有効である' do
    assert(@part.valid?)
  end
end
