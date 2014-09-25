include Warden::Test::Helpers
Warden.test_mode!

# Feature: Create job
#   As a processor
#   I want to create Jobs
feature 'Create job' do
	before(:each) do
		@me = sign_in_as_processor
		@state = FactoryGirl.create(:state)
		@county = FactoryGirl.create(:county, state: @state)
		@zipcode = FactoryGirl.create(:zipcode, state: @state.abbreviation)
		@client = FactoryGirl.create(:client)
		@branch = FactoryGirl.create(:branch, client: @client)
		@employee = FactoryGirl.create(:user, branch: @branch)
		visit root_path
	end
 
  after(:each) do
    Warden.test_reset!
  end

	# Scenario: Create a new tracking job
	#   Given I click on the "New Tracking Job" button
	#   When I complete the form
	#   Then I see the newly created tracking job
	scenario 'fill in new tracking job form' do
		product = FactoryGirl.create(:product, job_type: 'tracking')
		click_on "Tracking Job"
		fill_in_common_fields
		fill_in	'Close Date', with: 2.days.ago
		fill_in 'Deed of trust number', with: "55555"
		fill_in 'Lender', with: "Hobo Bank"
		fill_in 'Beneficiary Account', with: "12345"
		fill_in 'Payoff Amount', with: "10000.00"
		click_on 'Create Job'
		expect(page).to have_content("Job was successfully created")
		expect(page).to have_content(product.name)
		expect(page).to have_content("File Number: 9191919")
		expect(page).to have_content("This tracking job was requested")
	end

	# Scenario: Goes to new job form after creating job
	#   Given I click on the "New Tracking Job" button
	#   When I complete the form
	#   When I click 'Save & New Job'
	#   Then I see the new job form again
	scenario 'save and new job form' do
		product = FactoryGirl.create(:product, job_type: 'tracking')
		click_on "Tracking Job"
		fill_in_common_fields
		fill_in	'Close Date', with: 2.days.ago
		fill_in 'Deed of trust number', with: "55555"
		fill_in 'Lender', with: "Hobo Bank"
		fill_in 'Beneficiary Account', with: "12345"
		fill_in 'Payoff Amount', with: "10000.00"
		click_on 'Save & New Job'
		expect(page).to have_content("New Tracking Job")
	end

	# Scenario: Create a new special job
	#   Given I click on the "New Special Job" button
	#   When I complete the form
	#   Then I see the newly created special job
	scenario 'fill in new special job form' do 
		product = FactoryGirl.create(:product, job_type: 'special')
		click_on "Special Job"
		fill_in_common_fields
		fill_in	'Close Date', with: 2.days.ago
		fill_in 'Borrower/Grantor', with: "Fiesty Pants"
		fill_in 'Deed of trust number', with: "55555"
		fill_in 'Lender/Beneficiary', with: "Hobo Bank"
		fill_in 'Beneficiary Account', with: "12345"
		fill_in 'Payoff Amount', with: "10000.00"
		click_on 'Create Job'
		expect(page).to have_content("Job was successfully created")
		expect(page).to have_content(product.name)
		expect(page).to have_content("File Number: 9191919")
		expect(page).to have_content("This special job was requested")
	end

	# Scenario: Create a new search job
	#   Given I click on the "New Search Job" button
	#   When I complete the form
	#   Then I see the newly created search job
	scenario 'fill in new search job form' do 
		product = FactoryGirl.create(:product, job_type: 'search')
		click_on "Search Job"
		fill_in_common_fields
		# save_and_open_page
		fill_in 'Previous Owner', with: "John"
		fill_in 'New Owner', with: "Gary"
		fill_in 'Parcel number', with: "12345"
		fill_in 'Legal Description', with: "A residential property"
		fill_in 'Developer', with: "Bob the builder"
		click_on 'Create Job'
		expect(page).to have_content("Job was successfully created")
		expect(page).to have_content(product.name)
		expect(page).to have_content("File Number: 9191919")
		expect(page).to have_content("This search job was requested")
	end

	def fill_in_common_fields
		fill_in 'File number', with: "9191919"
		select @client.name, from: 'Client'
		select @employee.name, from: 'Requestor'
		fill_in 'Address', with: "123 Any street"
		fill_in 'Zipcode', with: @zipcode.zipcode
		fill_in 'City', with: "Beverly Hills"
		select @state.name, from: 'State'
		select @county.name, from: 'County'
	end

end
