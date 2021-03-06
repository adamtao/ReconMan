require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Admin wants to delete a county
#   As an admin user
#   I want to delete a county
#   So jobs aren't added for it
feature 'Deletes a county', :devise do

	before(:all) do
    @county = create(:county)
  end

  before(:each) do
		sign_in_as_admin
	end

  after(:each) do
    Warden.test_reset!
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
  end

  scenario "successfully" do
    visit state_county_path(@county.state, @county)
    click_on "Delete"

    expect(County.exists?(@county.id)).to be(false)
    expect(current_path).to eq(state_path(@county.state))
  end

  scenario "with associated jobs, sees an error" do
    create(:job, county: @county)

    visit state_county_path(@county.state, @county)
    click_on "Delete"

    expect(County.exists?(@county.id)).to be(true)
    expect(current_path).to eq(state_county_path(@county.state, @county))
    expect(page).to have_content("Cannot delete")
  end

end
