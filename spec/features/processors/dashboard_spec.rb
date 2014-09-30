include Warden::Test::Helpers
Warden.test_mode!

# Feature: Dashboard functions
#   As a processor
#   I want to use the dashboard
feature 'Dashboard' do

	before(:each) do
		@me = sign_in_as_processor
		@tracking_product = create(:tracking_product)
		@search_product = create(:search_product)
		@special_product = create(:special_product)
    #		POPULATE A BUNCH OF EACH JOB, should this be done elsewhere?
#		@job = create(:job, job_type: 'tracking')
#		@job_product = create(:job_product,
#		job: @job,
#		product: @product,
# 	workflow_state: 'in_progress')
	end

  after(:each) do
    Warden.test_reset!
  end

	# Scenario: Complete a job by completing its only job product
	# 	Given I complete a job product
	#   And it is the only one for the job
	#   When I submit the form
	#   Then I see the job is complete
#scenario 'mark a solo job product complete' do
#	visit job_path(@job)
#	fill_in 'New deed of trust number', with: "777777"
#	click_on 'Mark Complete'
#	expect(page).to have_content("status: Complete")
#	expect(page).to have_content("Job Status: Complete")
#end

  scenario 'Sections: Tracking, Specials, Search'
  scenario 'Tracking section grays out recently searched jobs'
  scenario 'Tracking section has button to log search'
  scenario 'Tracking section has button to close job'
  scenario 'Tracking, close button has popup form with new DOT# and date filed, this clears the job'
  scenario 'Tracking section has sortable columns'
  scenario 'Tracking section has columns: File#, Client, Escrow Officer, Close Date, Due Date, County, DOT#, Actions'
  scenario 'Tracking section row has links on File#, Client, County'
  scenario 'Tracking section table is paginated'

  scenario 'Specials section has columns: File#, Client, Escrow Officer, Rush, Due Date, County, DOT#, Defect'
  scenario 'Specials section has sortable columns'
  scenario 'Specials section has pagination'
  scenario 'Specials section row has links on File#, Client, County'
  scenario 'Specials section has no actions buttons'

  scenario 'Search section has columns: Parcel#, Client, Address, City, State, Zip, County, Due Date, Needs'
  scenario 'Search section has sortable columns'
  scenario 'Search section has pagination'
  scenario 'Search section row has links on: parcel#, client, county'
  scenario 'Search section has no actions buttons'
end
