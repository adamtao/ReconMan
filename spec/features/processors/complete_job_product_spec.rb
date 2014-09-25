include Warden::Test::Helpers
Warden.test_mode!

# Feature: Complete job product
#   As a processor
#   I want to complete a JobProduct
feature 'Complete job product' do

	before(:each) do
		@me = sign_in_as_processor
		@product = FactoryGirl.create(:product, performs_search: true, job_type: 'tracking')
		@job = FactoryGirl.create(:job, job_type: 'tracking')
		@job_product = FactoryGirl.create(:job_product,
			job: @job,
			product: @product,
			workflow_state: 'in_progress')
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
		visit job_path(@job)
		fill_in 'New deed of trust number', with: "777777"
		click_on 'Mark Complete'
		expect(page).to have_content("status: Complete")
		expect(page).to have_content("Job Status: Complete")
	end

	# Scenario: Complete a job product but not the parent job
	# 	Given I complete a job product
	#   And it is one of many for the job
	#   When I submit the form
	#   Then I see the job is NOT complete
	scenario 'mark one job product complete of a multi-task job' do
		FactoryGirl.create(:job_product, job: @job,
			product: @product,
			workflow_state: 'in_progress')
		visit job_path(@job)
		within("#edit_job_product_#{@job_product.id}") do
			fill_in 'New deed of trust number', with: "77777"
			click_on 'Mark Complete'
		end
		expect(page).to have_content("status: Complete")
		expect(page).not_to have_content("Job Status: Complete")
		expect(page).to have_content("Job Status: New")
	end

end
