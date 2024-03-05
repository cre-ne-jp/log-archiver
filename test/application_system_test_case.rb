Capybara.server = :puma

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  #driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  driven_by :selenium, using: :headless_firefox, screen_size: [1400, 1400]

  def css_id_selector(id)
    "##{id}"
  end
end
