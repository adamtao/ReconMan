require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature "Admin runs report in excel format" do

  before do
    @task = FactoryGirl.create(:tracking_task,
      workflow_state: 'complete',
      deed_of_trust_number: "1234",
      new_deed_of_trust_number: "5678",
      cleared_on: 2.weeks.ago,
      recorded_on: 2.weeks.ago
    )
    @client = @task.job.client
    @incomplete_job = FactoryGirl.create(:tracking_job, client: @client, file_number: "9999")
    other_client = FactoryGirl.create(:client)
    @other_job = FactoryGirl.create(:tracking_job, client: other_client, file_number: "8888")
    sign_in_as_admin
    visit root_path
  end

  after(:each) do
    Warden.test_reset!
  end

  scenario "successfully" do
    click_on 'Reports'
    select @client.name, from: 'Client'
    fill_in 'Start on', with: 1.month.ago
    fill_in 'End on', with: 1.day.from_now
    click_on 'Run Report'

    click_on 'Excel'

    expect(page.response_headers['Content-Type']).to match(/xls/)
  end
end
