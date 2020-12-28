require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Search tracking task
#   As a processor
#   I want to work with tracking tasks
feature 'Work with tracking task' do
	before(:each) do
		sign_in_as_processor
	end

  after(:each) do
    Warden.test_reset!
  end

	# Scenario: Processor performs and records a search
	# 	Given I have a tracking job for a county with ONLINE tracking
	#   When I provide the search URL
	#   Then I see the task is "In progress"
	scenario 'records search' do
    county = create(:county, search_url: "http://foo.bar.com/")
    job = create(:tracking_job, county: county)
		visit job_path(job)

		fill_in 'tracking_task_search_url', with: 'http://yomama.lvh.me'
		click_on 'Save'

		expect(page).to have_content("Status: In progress")
	end

  # Scenario: Processor edits a tracking task
  #   Given I have a tracking task
  #   When I edit that task
  #   Then I see the updated info and it is not complete
  scenario 'edits task does not change the status' do
    job = create(:tracking_job)
    job.reload
    task = job.tasks.first
    visit edit_job_task_path(job, task)

    click_on 'Update'

    expect(page).not_to have_content("Status: Complete")
  end

	# Scenario: Processor advances to first notice
	# 	Given I have a tracking job
	#   When I indicate the first notice is sent
	#   Then I see the task is "First Notice"
	scenario 'sends first notice' do
    job = create(:tracking_job)
		visit job_path(job)

		click_on 'First Notice Sent'

		expect(page).to have_content("Status: First notice")
    expect(page).to have_content("First Notice sent on")
	end

	# Scenario: Processor advances to second notice
	# 	Given I have a tracking job where the first notice is sent
	#   When I indicate the second notice is sent
	#   Then I see the task is "Second Notice"
	scenario 'sends second notice' do
    job = create(:tracking_job)
    job.reload
    task = job.tasks.first
    task.send_first_notice!
		visit job_path(job)

		click_on 'Second Notice Sent'

		expect(page).to have_content("Status: Second notice")
    expect(page).to have_content("First Notice sent on")
    expect(page).to have_content("Second Notice sent on")
	end
end
