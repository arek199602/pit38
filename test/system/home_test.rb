require "application_system_test_case"

# Smoke test: dowodzi, że cały pipeline (Rails -> Vite -> przeglądarka -> Vue)
# działa end-to-end. Strona główna renderuje aplikację Inertia/Vue klient-side.
class HomeTest < ApplicationSystemTestCase
  test "strona główna renderuje aplikację Inertia/Vue" do
    visit root_path

    assert_text "Rails version"
    assert_text "Vue version"
  end
end
