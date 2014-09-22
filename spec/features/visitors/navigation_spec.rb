# Feature: Navigation links
#   As a visitor
#   I want to see navigation links
#   So I can find sign in, or remember password
feature 'Navigation links', :devise do

  # Scenario: View navigation links
  #   Given I am a visitor
  #   When I visit the home page
  #   Then I see links: "sign in," "Forgot your password,"
  scenario 'view navigation links' do
    visit root_path
    expect(page).to have_content 'Forgot your password'
    expect(page).to have_content 'Sign in'
    # expect(page).to have_content 'Sign up'
  end

end
