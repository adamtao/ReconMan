include Warden::Test::Helpers
Warden.test_mode!

# Feature: Defect in reconveyance found 
#   As a processor
#   I want to record a defect in reconveyance
#   So a new defect clearance job is created
feature 'Record defect on a reconveyance' do
	before(:each) do
		@me = sign_in_as_processor
		@product = FactoryGirl.create(:product, performs_search: true, job_type: 'tracking')
		@defect_product = FactoryGirl.create(:product, name: "Defect Clearance", price_cents: 4444)
    @job = FactoryGirl.create(:job, job_type: 'tracking')
    @job_product = FactoryGirl.create(:job_product, job: @job, product: @product, search_url: 'http://foo', workflow_state: 'in_progress')
	end

  after(:each) do
    Warden.test_reset!
  end

	# Scenario: Processor marks a reconveyance as "defect" status 
	# 	Given I have a tracking job whose reconveyance is stuck
	#   When I visit the job page and mark the job product with a defect state
	#   Then I see the job product is "Defect"
	scenario 'processor marks a job product as a defect' do 
		visit job_path(@job)
    click_on 'Mark Defect'
		expect(page).to have_content("status: Defect")
	end

	# Scenario: Processor marks a defect and system created defect clearance job
	#   Given I mark a defect
	#   When I click the button
	#   Then I see the defect clearance job
  scenario 'defect clearance job created automatically' do 
  	visit job_path(@job)
  	click_on 'Mark Defect'
  	expect(page).to have_content("Defect Clearance")
  end

end
