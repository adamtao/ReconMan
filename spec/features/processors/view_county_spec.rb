require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'View County' do

	before(:all) do
    @client = create(:client)
    @state = create(:state)
    @county = create(:county, state: @state)
    create_list(:tracking_job, 30, county: @county)
  end

	before(:each) do
		sign_in_as_processor
		visit state_county_path(@state, @county)
	end

  after(:each) do
    Warden.test_reset!
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
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
