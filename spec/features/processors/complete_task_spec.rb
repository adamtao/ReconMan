require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Complete task
#   As a processor
#   I want to complete a Task
feature 'Complete task', :devise do

	before(:each) do
		@me = sign_in_as_processor
    @job = FactoryGirl.create(:tracking_job)
    @job.reload
	end

  after(:each) do
    Warden.test_reset!
  end

	# Scenario: Complete a job by completing its only task
	# 	Given I complete a task
	#   And it is the only one for the job
	#   When I submit the form
	#   Then I see the job is complete
	scenario 'mark a solo task complete' do
		visit job_path(@job)

		fill_in 'Release Number', with: "777777"
    fill_in 'Recorded on', with: I18n.l(Date.today, format: :long)
		click_on 'Mark Complete'

		expect(page).to have_content("Status: Complete")
		expect(page).to have_content("Job Status: Complete")
    expect(page).not_to have_css("form.edit_task")
	end

	# Scenario: Complete a task but not the parent job
	# 	Given I complete a task
	#   And it is one of many for the job
	#   When I submit the form
	#   Then I see the job is NOT complete
	scenario 'mark one task complete of a multi-task job' do
    task = @job.tasks.first
    task.update_column(:search_url, "http://search.lvh.me")
		create(:tracking_task, job: @job)
		visit job_path(@job)

		within("#edit_tracking_task_#{task.id}") do
			fill_in 'Release Number', with: "77777"
			click_on 'Mark Complete'
		end

		expect(page).to have_content("Status: Complete")
		expect(page).not_to have_content("Job Status: Complete")
		expect(page).to have_content("Job Status: New")
	end

end
