include Warden::Test::Helpers
Warden.test_mode!

# Feature: Create client
#   As a processor
#   I want to create a new Client
feature 'Create client' do

	before(:each) do
		sign_in_as_processor
		visit new_client_path
	end

  after(:each) do
    Warden.test_reset!
  end

	# Scenario: Client cannot be created with invalid data
	# 	Given I leave the new client form blank
	#   When I submit the form
	#   Then I see an invalid client message
	scenario 'incomplete form' do
		click_button 'Create Client'

		expect(page).to have_content 'Please review the problems below'
	end

	# Scenario: Client is created with data
	# 	Given I leave the new client form blank
	#   When I submit the form
	#   Then I see an confirmation message
	scenario 'complete and valid form' do
		fill_in 'Name', with: "New Client #{Time.now.to_s}"
		click_button 'Create Client'

		expect(page).to have_content 'Client was successfully created'
	end

end
