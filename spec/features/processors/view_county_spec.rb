require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'View County' do

	before(:each) do
    @client = create(:client)
    @state = create(:state)
    @county = create(:county, state: @state)
    create_list(:job, 30, county: @county)

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
    j = @county.jobs.last

    click_on 'Next'

    expect(page).to have_link(j.file_number, href: job_path(j))
	end
end
