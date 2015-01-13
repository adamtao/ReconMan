require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Search for a job
#   As a processor
#   I want to search for a job by file number
#   So I can process the job
feature "Search by file number", :devise do

  before do
    @me = sign_in_as_processor
    @tracking_jobs = FactoryGirl.create_list(:tracking_job, 21)
    visit root_path
  end

  after do
    Warden.test_reset!
  end

  # Scenario: Search successfully one result
  #   As a processor
  #   When I search for an exact job number
  #   I want to jump directly to the job
  scenario "with one search result" do
    job = @tracking_jobs.first
    job.update_column(:file_number, "UNIQUENUMBER123")

    within(:css, "form#job_search") do
      fill_in "q_file_number_cont", with: job.file_number
      click_on "search"
    end

    expect(current_path).to eq(job_path(job))
  end

  # Scenario: Multiple search results link to each
  #   As a processor
  #   When I search for a partial file number
  #   I expect to see links to multiple matching jobs
  scenario "with multiple results" do
    @tracking_jobs.each do |tj|
      tj.update_column(:file_number, "AAA#{tj.file_number}")
    end
    job = @tracking_jobs.first

    within(:css, "form#job_search") do
      fill_in "q_file_number_cont", with: "AAA"
      click_on "search"
    end

    expect(page).to have_link(job.file_number, href: job_path(job))
    expect(page).to have_link("Next")
  end
end
# Search by other fields
#  scenario "by seller name"
#  scenario "by buyer name"
#  scenario "by escrow account number"

