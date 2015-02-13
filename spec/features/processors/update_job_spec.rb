require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Update a job
#   As a processor
#   I want to edit and update Jobs
feature 'Create job' do
	before(:each) do
		@me = sign_in_as_processor
    @client = FactoryGirl.create(:client)
    @branch = FactoryGirl.create(:branch, client: @client)
    @employee = FactoryGirl.create(:user, branch: @branch)
    @tracking_job = FactoryGirl.create(:tracking_job, client: @client, requestor: @employee)
    @tracking_job.reload

		visit edit_job_path(@tracking_job)
	end

  after(:each) do
    Warden.test_reset!
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
