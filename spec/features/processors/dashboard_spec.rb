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
		@job = create(:job, job_type: 'tracking')
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
  scenario 'mark a solo job product complete' do
    skip "I think this was going to be a popup, but might be totally invalid now"
    visit job_path(@job)
    fill_in 'New deed of trust number', with: "777777"
    click_on 'Mark Complete'
    expect(page).to have_content("status: Complete")
    expect(page).to have_content("Job Status: Complete")
  end
end
