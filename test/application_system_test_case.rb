require "test_helper"

require 'capybara/rails'

Capybara.server = :webrick

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_firefox, screen_size: [1400, 1400]
end
