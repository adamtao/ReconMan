require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Create job
#   As a processor
#   I want to create Document type Jobs
feature 'Create Document job', :devise do
	before(:all) do
    @state = create(:state)
    @county = create(:county, state: @state)
    @zipcode = create(:zipcode, state: @state.abbreviation)
    @lender = create(:lender)
    @client = create(:client)
    @branch = create(:branch, client: @client)
    @employee = create(:user, branch: @branch)
  end

	before(:each) do
		@me = sign_in_as_processor
		visit root_path
	end

  after(:each) do
    Warden.test_reset!
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
  end

  scenario "successfully" do
    product = create(:product, job_type: 'documentation')

    within("ul#job-types") do
      click_on "Documentation"
    end
		fill_in_common_fields
		fill_in	'Close Date', with: 2.days.ago
		fill_in 'Deed of trust number', with: "55555"
    select @lender.name, from: 'Lender'
		fill_in 'Beneficiary Account', with: "12345"
		fill_in 'Payoff Amount', with: "10000.00"
		click_on 'Create Job'

    job = Job.last
    expect(job.tasks.first.type).to eq("DocumentationTask")
    expect(job.tasks.first).to be_an_instance_of(DocumentationTask)
		expect(page).to have_content("Job was successfully created")
		expect(page).to have_content(product.name)
		expect(page).to have_content("File: 9191919")
    expect(page).to have_content(@lender.name)
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
