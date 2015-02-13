require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Update document job
#   As a processor
#   I want to update Document type Jobs
#   So that work gets done and client can be billed
feature 'Update Document job', :devise do
	before(:each) do
		@me = sign_in_as_processor
    @task = FactoryGirl.create(:documentation_task)
    @job = @task.job
		visit job_path(@job)
	end

  after(:each) do
    Warden.test_reset!
  end

  scenario "Enter document filing date" do
    file_on = 2.days.ago
		fill_in	'Docs delivered on', with: file_on
		click_on 'Update'

    @task.reload
    expect(@task.docs_delivered_on.to_date).to eq(file_on.to_date)
    # Or, just show the date in the field for now
    #expect(page).to have_content(I18n.l file_on.to_date, format: :default)
  end

  scenario "Indicate reconveyance is filed" do
    check "Reconveyance filed"
    click_on 'Update'

    @task.reload
    expect(@task.reconveyance_filed).to be(true)
    # Or, just show the checkbox as checked for now
    #expect(page).to have_content("Reconveyance filed? Yes")
  end

  scenario "Indicate job is complete" do
    check "Job complete"
    click_on 'Update'

    @task.reload
    expect(@task.workflow_state).to eq('complete')
  end

end
