require 'test_helper'

class MessageSearchTest < ActiveSupport::TestCase
  setup do
    @search = build(:message_search)
  end

  test '有効である' do
    assert(@search.valid?)
  end

  test 'query は必須' do
    @search.query = nil
    refute(@search.valid?)
  end

  test 'query は空白のみではならない' do
    @search.query = ' ' * 10
    refute(@search.valid?)
  end

  test 'channel は必須' do
    @search.channel = nil
    refute(@search.valid?)
  end

  test 'channel がデータベースに存在しなければならない' do
    @search.channel = 'not_found'
    refute(@search.valid?)
  end

  test 'since と until が共に存在する場合、until は since 以上' do
    @search.since = Date.new(2017, 1, 1)

    @search.until = Date.new(2017, 1, 2)
    assert(@search.valid?, 'since < until は有効')

    @search.until = Date.new(2017, 1, 1)
    assert(@search.valid?, 'since == until は有効')

    @search.until = Date.new(2016, 12, 31)
    refute(@search.valid?, 'since > until は無効')
  end
end
