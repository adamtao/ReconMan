require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature "Log a title search" do

  before(:each) do
    @me = sign_in_as_processor
    county = FactoryGirl.create(:county, search_url: "http://county.lvh.me")
    @job_product = FactoryGirl.create(:tracking_job_product)
    @job = @job_product.job
    @job.update_column(:county_id, county.id)
  end

  after do
    Warden.test_reset!
  end

  scenario "first search performed, record URL, search is logged" do
    visit job_path(@job)

    fill_in :job_product_search_url, with: "http://county.lvh.me"
    click_on "Save"

    @job_product.reload
    expect(page).to have_link("Perform Search")
    expect(@job_product.search_logs.length).to eq(1)
    expect(page).to have_css("ul.log li", text: @me.name)
    expect(page).to have_css("ul.log li", text: '|Not Cleared')
  end

  scenario "second search performed, search is logged" do
    @job_product.update_column(:search_url, 'http://county.lvh.me')
    FactoryGirl.create(:search_log, job_product: @job_product, status: "Not Cleared")
    visit job_path(@job)

    click_on "Perform Search"
    @job_product.reload

    expect(@job_product.search_logs.length).to eq(2)
  end

  scenario "mark complete, updates final search if one exists" do
    @job_product.update_column(:search_url, 'http://county.lvh.me')
    FactoryGirl.create(:search_log, job_product: @job_product, status: "Not Cleared")
    visit job_path(@job)

    fill_in "Release Number", with: "12345"
    fill_in "Recorded on", with: Date.today
    click_on "Mark Complete"

    @job_product.reload
    expect(@job_product.search_logs.length).to eq(1)
    expect(@job_product.search_logs.last.status).to eq('Cleared')
  end

  scenario "mark complete, records final search if none exist" do
    @job_product.update_column(:search_url, 'http://county.lvh.me')
    visit job_path(@job)

    fill_in "Release Number", with: "12345"
    fill_in "Recorded on", with: Date.today
    click_on "Mark Complete"

    @job_product.reload
    expect(@job_product.search_logs.length).to eq(1)
    expect(@job_product.search_logs.last.status).to eq('Cleared')
  end

end

