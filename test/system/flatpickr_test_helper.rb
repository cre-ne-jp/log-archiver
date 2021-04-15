module FlatpickrTestHelper
  include FlatpickrHelper

  def assert_date_picker_work(target_id)
    assert_flatpickr_work(target_id, '2021-01-02', '2021-01-02')
  end

  def assert_datetime_picker_work(target_id)
    assert_flatpickr_work(target_id,
                          '2021-01-02T03:45:21T09:00',
                          '2021-01-02 03:45:21')
  end

  def assert_flatpickr_work(target_id, set_date_value, expected_text)
    assert_selector(css_id_selector(target_id))

    execute_script(javascript_with_fp(target_id, <<~JS))
      fp.setDate("#{set_date_value}", true);
    JS

    target_input = find_by_id(target_id)
    assert_equal(expected_text, target_input.value, '値が設定される')

    toggle_button = find_by_id(flatpickr_id(target_id, 'toggle'))

    toggle_button.click
    assert(flatpickr_open?(target_id), 'カレンダーアイコンをクリックするとFlatpickrが開く')

    sleep(0.5)

    toggle_button.click
    refute(flatpickr_open?(target_id), 'カレンダーアイコンをクリックするとFlatpickrが閉じる')

    sleep(0.5)

    clear_button = find_by_id(flatpickr_id(target_id, 'clear'))
    clear_button.click
    assert_equal('', target_input.value, '値がクリアされる')
  end

  def javascript_with_fp(element_id, code)
    <<~JS
      const fp = document.getElementById("#{flatpickr_id(element_id)}")._flatpickr;
      #{code}
    JS
  end

  def flatpickr_open?(element_id)
    execute_script(javascript_with_fp(element_id, <<~JS))
      return fp.isOpen;
    JS
  end
end
