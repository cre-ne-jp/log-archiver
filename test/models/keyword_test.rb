require 'test_helper'

class KeywordTest < ActiveSupport::TestCase
  setup do
    @keyword = create(:keyword)
  end

  test 'title は必須' do
    @keyword.title = nil
    refute(@keyword.valid?)
  end

  test 'title は空白のみではならない' do
    @keyword.title = ' ' * 10
    refute(@keyword.valid?)
  end

  test 'display_title は必須' do
    @keyword.display_title = nil
    refute(@keyword.valid?)
  end

  test 'display_title は空白のみではならない' do
    @keyword.display_title = ' ' * 10
    refute(@keyword.valid?)
  end
end
