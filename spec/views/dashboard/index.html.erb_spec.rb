include Warden::Test::Helpers
Warden.test_mode!

#TODO: Convert these features specs into view specs
# Feature: Dashboard functions
#   As a processor
#   I want to use the dashboard
feature 'Dashboard' do

	before(:each) do
    skip "Need to convert feature spec into view spec"
		@me = sign_in_as_processor
  end

  before(:all) do
		@tracking_product = create(:tracking_product)
		@search_product = create(:search_product)
		@special_product = create(:special_product)
    @tracking_jobs = create_list(:tracking_job, 5)
    @search_jobs = create_list(:search_job, 5)
    @special_jobs = create_list(:special_job, 5)
	end

  after(:each) do
    Warden.test_reset!
  end

	# Scenario: Complete a job by completing its only job product
	# 	Given I complete a job product
	#   And it is the only one for the job
	#   When I submit the form
	#   Then I see the job is complete
  scenario 'mark a solo job product complete' do
    skip "I think this was going to be a popup, but might be totally invalid now"
    visit job_path(@job)

    fill_in 'New deed of trust number', with: "777777"
    click_on 'Mark Complete'

    expect(page).to have_content("status: Complete")
    expect(page).to have_content("Job Status: Complete")
  end

  # Scenario: Visiting the dashboard, I see job type sections
  #   Given I am logged in
  #   When I visit the dashboard
  #   Then I see three sections: tracking, specials, search
  scenario 'Sections: Tracking, Search, Special' do
    visit root_path

    within '#tracking_section' do
      expect(page).to have_content 'Tracking'
    end
    within '#search_section' do
      expect(page).to have_content 'Search'
    end
    within '#special_section' do
      expect(page).to have_content 'Special'
    end
  end

  scenario 'Tracking section grays out recently searched jobs'

  scenario 'Tracking section has rows of tracking jobs only' do
    visit root_path
    job = @tracking_jobs.first
    search_job = @search_jobs.first

    tracking_section = page.find('#tracking_section')

    expect(tracking_section).to have_link(job.file_number, href: job_path(job))
    expect(tracking_section).not_to have_link(search_job.file_number, href: job_path(search_job))
  end

  scenario 'Tracking section has button to log search'
  scenario 'Tracking section has button to close job'
  scenario 'Tracking, close button has popup form with new DOT# and date filed, this clears the job'
  scenario 'Tracking section has sortable columns'

  scenario 'Tracking section has columns: File#, Client, Escrow Officer, Close Date, Due Date, County, DOT#, Actions' do
    visit root_path

    tracking_section = page.find('#tracking_section')

    expect(tracking_section).to have_content('File')
    expect(tracking_section).to have_content('Client')
    expect(tracking_section).to have_content('Escrow Officer')
    expect(tracking_section).to have_content('Close Date')
    expect(tracking_section).to have_content('Due Date')
    expect(tracking_section).not_to have_content('Rush')
    expect(tracking_section).to have_content('County')
    expect(tracking_section).to have_content('DOT')
    expect(tracking_section).to have_content('Actions')
  end

  scenario 'Tracking section row has links on File#, Client, County'
  scenario 'Tracking section table is paginated'

  scenario 'Specials section has rows of special jobs only' do
    visit root_path
    job = @special_jobs.first
    search_job = @search_jobs.first

    special_section = page.find('#special_section')

    expect(special_section).to have_link(job.file_number, href: job_path(job))
    expect(special_section).not_to have_link(search_job.file_number, href: job_path(search_job))
  end

  scenario 'Specials section has columns: File#, Client, Escrow Officer, Rush, Due Date, County, DOT#, Defect' do
    visit root_path

    specials_section = page.find('#special_section')

    expect(specials_section).to have_content('File')
    expect(specials_section).to have_content('Client')
    expect(specials_section).to have_content('Escrow Officer')
    expect(specials_section).to have_content('Rush')
    expect(specials_section).to have_content('Due Date')
    expect(specials_section).not_to have_content('Close Date')
    expect(specials_section).to have_content('County')
    expect(specials_section).to have_content('DOT')
    expect(specials_section).to have_content('Defect')
  end

  scenario 'Specials section has sortable columns'
  scenario 'Specials section has pagination'
  scenario 'Specials section row has links on File#, Client, County'
  scenario 'Specials section has no actions buttons'

  scenario 'Search section has rows of search jobs only' do
    visit root_path
    job = @special_jobs.first
    search_job = @search_jobs.first

    search_section = page.find('#search_section')

    expect(search_section).not_to have_link(job.file_number, href: job_path(job))
    expect(search_section).to have_link(search_job.file_number, href: job_path(search_job))
  end

  scenario 'Search section has columns: Parcel#, Client, Address, City, State, Zip, County, Due Date, Needs' do
    visit root_path

    search_section = page.find('#search_section')

    expect(search_section).to have_content('Parcel')
    expect(search_section).to have_content('Client')
    expect(search_section).to have_content('Address')
    expect(search_section).to have_content('City')
    expect(search_section).to have_content('State')
    expect(search_section).to have_content('Zip')
    expect(search_section).to have_content('Due Date')
    expect(search_section).not_to have_content('Close Date')
    expect(search_section).to have_content('County')
    expect(search_section).to have_content('Needs')
  end

  scenario 'Search section has sortable columns'
  scenario 'Search section has pagination'
  scenario 'Search section row has links on: parcel#, client, county'
  scenario 'Search section has no actions buttons'
end
