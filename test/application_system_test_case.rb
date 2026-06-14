require "test_helper"
require "capybara-playwright-driver"

# Capybara + Playwright (deliberately NOT Selenium - see CLAUDE.md).
# Playwright isn't built into Rails, so we register our own driver.
Capybara.register_driver(:playwright) do |app|
  Capybara::Playwright::Driver.new(app, browser_type: :chromium, headless: true)
end

# The first visit triggers a Vite build (config/vite.json -> test: autoBuild), so allow extra time.
Capybara.default_max_wait_time = 15

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :playwright
end
