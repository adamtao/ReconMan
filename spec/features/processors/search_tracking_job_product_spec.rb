# Feature: Search tracking job product
#   As a processor
#   I want to complete a JobProduct
feature 'Search tracking job product' do
	before(:each) do
		@me = sign_in_as_processor
		@job = FactoryGirl.create(:job, job_type: 'tracking')
	end

	after(:each) do
		Warden.test_reset!
	end

	scenario 'record search url' # advance state

end