require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Checkout a County
#   As a processor
#   I want to checkout a county
#   So I can process that county's jobs
feature "Checkout a County", :devise do
  before do
    @me = sign_in_as_processor
    @county = FactoryGirl.create(:county)
    @tracking_jobs = FactoryGirl.create_list(:tracking_job, 3, county: @county)
    visit root_path
  end

  after do
    Warden.test_reset!
  end

  # Scenario: See counties on dashboard
  #   As a processor
  #   I want to see counties needing work on the dashboard
  #   So that I can check them out to start work.
  scenario "list counties needing work in a dropdown on dashboard" do
    expect(page).to have_content("#{@county.name}, #{@county.state.abbreviation} (3)")
    expect(page).to have_button("checkout")
  end

  # Scenario: checkout county, go to first job
  #   As a processor
  #   I want to checkout a county and go directly to its first job
  #   So that I can process the job
  scenario "successfully" do
    click_on "checkout"

    expect(current_path).to eq(job_path(@tracking_jobs.first))
  end

  # Scenario: Next button
  #   As a processor with a county checked out
  #   I want to see a "next job" button
  #   So that I can quickly continue work in that county
  scenario "go to next job" do
    click_on "checkout"
    click_on "next job"
    click_on "next job"

    expect(current_path).to eq(job_path(@tracking_jobs[2]))
  end

  # Scenario: checkout time perpetuates each time job action performed
  #   As a processor with a county checked out
  #   I want my checkout time updated each time I update the job
  #   So that I can continue to work on that county
  scenario "perpetuates checkout time" do
    click_on "checkout"
    @county.update_column(:checked_out_at, 2.minutes.ago)
    original_checkout_time = @county.checked_out_at

    click_on "next job"
    @county.reload

    expect(@county.checked_out_at).to be > original_checkout_time
  end

  # Scenario: checkout timesout before loading next job
  #   As a processor with a county checked out long ago
  #   I want the next button to return me to the dashboard
  #   So that I don't clobber someone else who has started working on the job
  #   And I can checkout a different county
  scenario "checks timeout before loading next job" do
    click_on "checkout"
    @county.update_column(:checked_out_at, 1.day.ago)

    click_on "next job"

    @county.reload
    expect(current_path).to eq(root_path)
    expect(@county.checked_out?).to be(false)
    expect(@me.checked_out_county).to be(false)
  end

  # Scenario: check in one county when trying to checkout another
  #   As a processor with a county checked out
  #   I want to checkout another county, auto-checking in the first
  #   So that I can work on the new one and others can work on the other
  scenario "only one county at a time" do
    @me.checkout_county(@county)
    county2 = FactoryGirl.create(:county)
    FactoryGirl.create(:tracking_job, county: county2)
    visit root_path

    select county2.name, from: "id"
    click_on "checkout"

    @county.reload
    expect(@county.checked_out?).to be(false)
    expect(@me.checked_out_county).to eq(county2)
  end

  # Scenario: check in county manually
  #   As a processor with a county checked out
  #   I want to check in the county
  #   So that others can work on it while I eat a sandwich
  scenario "check it back in" do
    click_on "checkout"

    click_on "check-in county"

    @county.reload
    expect(current_path).to eq(root_path)
    expect(@county.checked_out?).to be(false)
    expect(@me.checked_out_county).to be(false)
  end

  # Scenario: sign out checks in county
  #   As a processor with a county checked out
  #   I want the county checked in when I log out
  #   So that others can work on that county
  scenario "sign out checks in county" do
    click_on "checkout"

    click_on "Logout"

    @county.reload
    expect(@county.checked_out?).to be(false)
    expect(@me.checked_out_county).to be(false)
  end
end
