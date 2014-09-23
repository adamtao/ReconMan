# Feature: Complete job product
#   As a processor
#   I want to complete a JobProduct
feature 'Complete job product' do
	before(:each) do
		@me = sign_in_as_processor
		@job = FactoryGirl.create(:job)
	end

	after(:each) do
		Warden.test_reset!
	end

	scenario 'mark a solo job product complete'
	scenario 'mark one job product complete of a multi-task job'

end