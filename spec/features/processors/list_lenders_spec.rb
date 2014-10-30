require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: List lenders
#   As a processor
#   I want to have access to a list of lenders
#   So that I can add more or view details
feature "List lenders" do
  before(:each) do
    sign_in_as_processor
    visit root_path
  end

  after(:each) do
    Warden.test_reset!
  end

  scenario "Lenders link appears in navigation" do
    expect(page).to have_link("Lenders", href: lenders_path)
  end

  scenario "Clicking lenders page shows all lenders" do
    lender = create(:lender)

    visit lenders_path

    expect(page).to have_link(lender.name, href: lender_path(lender))
  end

  scenario "Should have a button to create new lender" do
    visit lenders_path

    expect(page).to have_link("New Lender", href: new_lender_path)
  end

end
