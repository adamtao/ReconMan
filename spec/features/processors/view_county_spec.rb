require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'View County' do

	before(:each) do
    @client = FactoryGirl.create(:client)
    @state = FactoryGirl.create(:state)
    @county = FactoryGirl.create(:county, state: @state)
    FactoryGirl.create_list(:tracking_job, 30, county: @county)

		sign_in_as_processor
		visit state_county_path(@state, @county)
	end

  after(:each) do
    Warden.test_reset!
  end

	scenario 'shows only 20 jobs' do
    expect(page).to have_css('table#incomplete-jobs tbody tr', count: 20)
    expect(page).to have_link("Next")
	end

	scenario 'clicking next shows next jobs' do
    click_on 'Next'

    expect(page).to have_css('table#incomplete-jobs tbody tr', count: 10)
	end
end
