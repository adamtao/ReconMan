require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Search for a job
#   As a processor
#   I want to search for a job by file number
#   So I can process the job
feature "Search", :devise do

  before :all do
    DatabaseCleaner.clean_with :truncation
    @tracking_jobs = FactoryGirl.create_list(:tracking_job, 21)
  end

  before :each do
    @me = sign_in_as_processor
    visit root_path
  end

  after :all do
    Warden.test_reset!
    DatabaseCleaner.clean_with :truncation
  end

  # Scenario: Search successfully one result
  #   As a processor
  #   When I search for an exact job number
  #   I want to jump directly to the job
  scenario "by file number with one search result" do
    job = @tracking_jobs.first
    job.update_column(:file_number, "UNIQUENUMBER123")

    within(:css, "form#job_search") do
      fill_in "q_file_number_or_new_owner_or_old_owner_or_address_cont", with: job.file_number
      click_on "search"
    end

    expect(current_path).to eq(job_path(job))
  end

  # Scenario: Multiple search results link to each
  #   As a processor
  #   When I search for a partial file number
  #   I expect to see links to multiple matching jobs
  scenario "by file number with multiple results" do
    @tracking_jobs.each do |tj|
      tj.update_column(:file_number, "AAA#{tj.file_number}")
    end
    job = @tracking_jobs.first

    within(:css, "form#job_search") do
      fill_in "q_file_number_or_new_owner_or_old_owner_or_address_cont", with: "AAA"
      click_on "search"
    end

    expect(page).to have_link(job.file_number, href: job_path(job))
    expect(page).to have_link("Next")
  end

  # Scenario: search for a seller name
  #   As a processor
  #   When I search for a name
  #   I expect to see job results of where seller names match
  scenario "by seller name" do
    @tracking_jobs.each do |tj|
      tj.update_column(:old_owner, "Bill Cosby")
    end
    job = @tracking_jobs.first

    within(:css, "form#job_search") do
      fill_in "q_file_number_or_new_owner_or_old_owner_or_address_cont", with: "Bill"
      click_on "search"
    end
    job.reload

    expect(page).to have_link(job.file_number, href: job_path(job))
  end

  # Scenario: search for a buyer name
  #   As a processor
  #   When I search for a name
  #   I expect to see job results of where buyer names match
  scenario "by buyer name" do
    @tracking_jobs.each do |tj|
      tj.update_column(:new_owner, "Bart Simpson")
    end
    job = @tracking_jobs.first

    within(:css, "form#job_search") do
      fill_in "q_file_number_or_new_owner_or_old_owner_or_address_cont", with: "Bart"
      click_on "search"
    end
    job.reload

    expect(page).to have_link(job.file_number, href: job_path(job))
  end

  # Scenario: search for an address
  #   As a processor
  #   When I search for an address
  #   I expect to see job results of where address match
  scenario "by address" do
    @tracking_jobs.each do |tj|
      tj.update_column(:address, "5107 Thomas")
    end
    job = @tracking_jobs.first

    within(:css, "form#job_search") do
      fill_in "q_file_number_or_new_owner_or_old_owner_or_address_cont", with: "5107 Th"
      click_on "search"
    end
    job.reload

    expect(page).to have_link(job.file_number, href: job_path(job))
  end
end
