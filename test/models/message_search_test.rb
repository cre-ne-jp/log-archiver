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

  test 'attributes が正しい' do
    attributes = @search.attributes

    assert_equal(@search.query, attributes.fetch('query'), 'query')
    assert_equal(@search.channel, attributes.fetch('channel'), 'channel')
    assert_equal(@search.since, attributes.fetch('since'), 'since')
    assert_equal(@search.until, attributes.fetch('until'), 'until')
    assert_equal(@search.page, attributes.fetch('page'), 'page')
  end

  test 'attributes= によって属性が正しく設定される' do
    channel = create(:channel_with_camel_case_name)
    attributes = {
      'query' => 'test',
      'channel' => channel.identifier,
      'since' => Date.new(2000, 1, 23),
      'until' => Date.new(2001, 12, 31),
      'page' => 12
    }

    @search.attributes = attributes

    assert_equal(attributes.fetch('query'), @search.query, 'query')
    assert_equal(attributes.fetch('channel'), @search.channel, 'channel')
    assert_equal(attributes.fetch('since'), @search.since, 'since')
    assert_equal(attributes.fetch('until'), @search.until, 'until')
    assert_equal(attributes.fetch('page'), @search.page, 'page')
  end

  test 'attributes_for_result_page が正しい' do
    attributes = @search.attributes_for_result_page

    assert_equal(@search.query, attributes.fetch('q'), 'query')
    assert_equal(@search.channel, attributes.fetch('channel'), 'channel')
    assert_equal(@search.since, attributes.fetch('since'), 'since')
    assert_equal(@search.until, attributes.fetch('until'), 'until')
    assert_equal(@search.page, attributes.fetch('page'), 'page')
  end

  test 'set_attributes_with_result_page_params によって属性が正しく設定される' do
    channel = create(:channel_with_camel_case_name)
    attributes = {
      'q' => 'test',
      'channel' => channel.identifier,
      'since' => '2000-01-23',
      'until' => '2001-12-31',
      'page' => 12
    }

    @search.set_attributes_with_result_page_params(attributes)

    assert_equal(attributes['q'], @search.query, 'query')
    assert_equal(attributes['channel'], @search.channel, 'channel')
    assert_equal(attributes['since'].to_date, @search.since, 'since')
    assert_equal(attributes['until'].to_date, @search.until, 'until')
    assert_equal(attributes['page'], @search.page, 'page')
  end
end
