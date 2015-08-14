require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Admin sees if a task is billed
#   As an admin
#   I want to see if a task is billed
#   So that I can bill the client if it isn't
feature "Toggle task billing status", :devise, :js do

  before do
    skip "Slow test"
    sign_in_as_admin
  end

  # Scenario: Show task as not billed
  scenario "not billed -> billed" do
    @tracking_task = FactoryGirl.create(:tracking_task)
    visit job_path(@tracking_task.job)

    check "Billed"

    sleep(0.5) # wait for ajax to go through
    @tracking_task.reload
    expect(@tracking_task.billed?).to be(true)
  end

  scenario "billed -> not billed" do
    @tracking_task = FactoryGirl.create(:tracking_task, billed: true)
    visit job_path(@tracking_task.job)

    uncheck "Billed"

    sleep(0.5) # wait for ajax to go through
    @tracking_task.reload
    expect(@tracking_task.billed?).to be(false)
  end
end
