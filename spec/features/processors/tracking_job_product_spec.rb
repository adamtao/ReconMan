include Warden::Test::Helpers
Warden.test_mode!

# Feature: Search tracking job product
#   As a processor
#   I want to record a search performed
feature 'Record search for job product' do
	before(:each) do
		@me = sign_in_as_processor
		@product = create(:tracking_product)
	end

  after(:each) do
    Warden.test_reset!
  end

	# Scenario: Processor performs and records a search
	# 	Given I have a tracking job for a county with ONLINE tracking
	#   When I provide the search URL
	#   Then I see the job product is "In progress"
	scenario 'processor records search' do
		county = create(:county, search_url: "http://foo.bar.com/")
		@job = create(:tracking_job, county: county)
		visit job_path(@job)

		fill_in 'job_product_search_url', with: 'http://yomama.lvh.me'
		click_on 'Save'

		expect(page).to have_content("status: In progress")
	end

	# Scenario: Offline job automatically moves to in_progress
	# 	Given I have a tracking job for a county with OFFLINE tracking
	#   Then I see the job product is "To be searched manually"
	scenario 'offline job moves to in_progress' do
		county = create(:county, search_url: nil)
		@job = create(:tracking_job, county: county)
		visit job_path(@job)

		expect(page).to have_content("status: To be searched manually")
	end

end
