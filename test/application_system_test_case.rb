require "test_helper"
require "capybara-playwright-driver"

# Capybara + Playwright (świadomie BEZ Selenium — patrz CLAUDE.md).
# Playwright nie jest wbudowany w Rails, więc rejestrujemy własny driver.
Capybara.register_driver(:playwright) do |app|
  Capybara::Playwright::Driver.new(app, browser_type: :chromium, headless: true)
end

# Pierwsza wizyta wyzwala build Vite (config/vite.json → test: autoBuild) — dajemy zapas czasu.
Capybara.default_max_wait_time = 15

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :playwright
end
