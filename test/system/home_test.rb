require "application_system_test_case"

# Smoke test: proves the whole pipeline (Rails -> Vite -> browser -> Vue) works
# end-to-end. The home page renders the Inertia/Vue app client-side.
class HomeTest < ApplicationSystemTestCase
  test "home page renders the Inertia/Vue app" do
    visit root_path

    assert_text "Rails version"
    assert_text "Vue version"
  end
end
