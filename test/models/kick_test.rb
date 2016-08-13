require 'test_helper'

class KickTest < ActiveSupport::TestCase
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
end
