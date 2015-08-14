require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Update a job
#   As a processor
#   I want to edit and update Jobs
feature 'Update tracking job' do
	before(:all) do
    @client = FactoryGirl.create(:client)
    @branch = FactoryGirl.create(:branch, client: @client)
    @employee = FactoryGirl.create(:user, branch: @branch)
    @tracking_job = FactoryGirl.create(:tracking_job, client: @client, requestor: @employee)
    @tracking_job.reload
  end

	before(:each) do
		@me = sign_in_as_processor
		visit edit_job_path(@tracking_job)
	end

  after(:each) do
    Warden.test_reset!
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
  end
	# Scenario: Edit an existing tracking job
	scenario 'successfully' do
    products_count = @tracking_job.tasks.length

    fill_in 'File number', with: 'abc123'
    click_on 'Update Job'
    @tracking_job.reload

    expect(page).to have_content('abc123')
    expect(@tracking_job.tasks.length).to eq(products_count)
	end

end

feature 'Update search job' do
	before(:each) do
		@me = sign_in_as_processor
    @client = FactoryGirl.create(:client)
    @branch = FactoryGirl.create(:branch, client: @client)
    @employee = FactoryGirl.create(:user, branch: @branch)
    @search_job = FactoryGirl.create(:search_job, client: @client, requestor: @employee)
    @search_job.reload

		visit edit_job_path(@search_job)
	end

  after(:each) do
    Warden.test_reset!
  end

	# Scenario: Edit an existing search job
	scenario 'successfully' do
    products_count = @search_job.tasks.length

    fill_in 'File number', with: 'xyz789'
    click_on 'Update Job'
    @search_job.reload

    expect(@search_job.tasks.length).to eq(products_count)
    expect(page).to have_content('xyz789')
	end


end
