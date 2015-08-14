require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature "Log a title search" do

  before :all do
    county = FactoryGirl.create(:county, search_url: "http://county.lvh.me")
    @task = FactoryGirl.create(:tracking_task)
    @job = @task.job
    @job.update_column(:county_id, county.id)
  end

  before(:each) do
    @me = sign_in_as_processor
  end

  after do
    Warden.test_reset!
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
  end

  scenario "first search performed, record URL, search is logged" do
    visit job_path(@job)

    fill_in :tracking_task_search_url, with: "http://county.lvh.me"
    click_on "Save"

    @task.reload
    expect(page).to have_link("Perform Search")
    expect(@task.search_logs.length).to eq(1)
    expect(page).to have_css("ul.log li", text: @me.name)
    expect(page).to have_css("ul.log li", text: '|Not Cleared')
  end

  scenario "second search performed, search is logged" do
    @task.update_column(:search_url, 'http://county.lvh.me')
    FactoryGirl.create(:search_log, task: @task, status: "Not Cleared")
    visit job_path(@job)

    click_on "Perform Search"
    @task.reload

    expect(@task.search_logs.length).to eq(2)
  end

  scenario "mark complete, updates final search if one exists" do
    @task.update_column(:search_url, 'http://county.lvh.me')
    FactoryGirl.create(:search_log, task: @task, status: "Not Cleared")
    visit job_path(@job)

    fill_in "Release Number", with: "12345"
    fill_in "Recorded on", with: Date.today
    click_on "Mark Complete"

    @task.reload
    expect(@task.search_logs.length).to eq(1)
    expect(@task.search_logs.last.status).to eq('Cleared')
  end

  scenario "mark complete, records final search if none exist" do
    @task.update_column(:search_url, 'http://county.lvh.me')
    visit job_path(@job)

    fill_in "Release Number", with: "12345"
    fill_in "Recorded on", with: Date.today
    click_on "Mark Complete"

    @task.reload
    expect(@task.search_logs.length).to eq(1)
    expect(@task.search_logs.last.status).to eq('Cleared')
  end

end

