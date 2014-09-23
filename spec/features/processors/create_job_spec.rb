# Feature: Create job
#   As a processor
#   I want to create a new Job
feature 'Create job' do
	before(:each) do
		@me = sign_in_as_processor
	end

	after(:each) do
		Warden.test_reset!
	end

	scenario 'fill in new tracking job form'
	scenario 'fill in new special job form'
	scenario 'fill in new search job form'

end