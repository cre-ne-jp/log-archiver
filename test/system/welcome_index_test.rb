require 'test_helper'
require 'application_system_test_case'

class WelcomeIndexTest < ApplicationSystemTestCase
  include FlatpickrHelper

  setup do
    create(:setting)
  end

  test 'Flatpickr on #message_search_since should work' do
    visit(root_url)

    click_link('検索')
    assert_selector('#search.active')

    target_id = 'message_search_since'
    assert_selector(css_id_selector(target_id))

    execute_script(javascript_with_fp(target_id, <<~JS))
      fp.setDate('2021-01-02', true);
    JS

    assert_equal('2021-01-02', find_by_id(target_id).value)
  end

  test 'Flatpickr on #message_search_until should work' do
    visit(root_url)

    click_link('検索')
    assert_selector('#search.active')

    target_id = 'message_search_until'
    assert_selector(css_id_selector(target_id))

    execute_script(javascript_with_fp(target_id, <<~JS))
      fp.setDate('2021-01-02', true);
    JS

    assert_equal('2021-01-02', find_by_id(target_id).value)
  end

  test 'minDate of #message_search_until should be set' do
    visit(root_url)

    click_link('検索')
    assert_selector('#search.active')

    assert_selector('#message_search_since')
    assert_selector('#message_search_until')

    execute_script(javascript_with_fp('message_search_since', <<~JS))
      fp.setDate('2021-01-02', true);
    JS

    min_date = execute_script(javascript_with_fp('message_search_until', <<~JS))
      return fp.config.minDate;
    JS
    assert_equal(Time.new(2021, 1, 2, 0, 0, 0, '+09:00'), min_date)
  end

  test 'maxDate of #message_search_since should be set' do
    visit(root_url)

    click_link('検索')
    assert_selector('#search.active')

    assert_selector('#message_search_since')
    assert_selector('#message_search_until')

    execute_script(javascript_with_fp('message_search_until', <<~JS))
      fp.setDate('2021-01-02', true);
    JS

    min_date = execute_script(javascript_with_fp('message_search_since', <<~JS))
      return fp.config.maxDate;
    JS
    assert_equal(Time.new(2021, 1, 2, 0, 0, 0, '+09:00'), min_date)
  end

  private

  def css_id_selector(id)
    "##{id}"
  end

  def javascript_with_fp(element_id, code)
    <<~JS
      let fp = document.getElementById("#{flatpickr_id(element_id)}")._flatpickr;
      #{code}
    JS
  end
end
