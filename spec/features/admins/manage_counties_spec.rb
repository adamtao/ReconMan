require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Admin wants to manage a county
#   As an admin user
#   I want to manage a county
#   So jobs can be processed for the county
feature 'Manages a county', :devise do

	before(:each) do
    @county = FactoryGirl.create(:county)
		sign_in_as_admin
	end

  after(:each) do
    Warden.test_reset!
  end

  scenario "Adds search_url generating fields" do
    visit edit_state_county_path(@county.state, @county)

    url_template = 'http://foo.bar/{{params}}'
    params = 'searchstring={{deed_of_trust_number}}'

    fill_in "Search template url", with: url_template
    fill_in "Search params", with: params
    select "GET", from: "Search method"
    click_on "Update"

    @county.reload
    expect(@county.search_method).to eq "GET"
    expect(@county.search_params).to eq params
    expect(@county.search_template_url).to eq url_template
  end

end
