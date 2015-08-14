require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Pagination' do

	before(:all) do
		@tracking_product = create(:tracking_product)
		@search_product = create(:search_product)
		@special_product = create(:special_product)
  end

	before(:each) do
		@me = sign_in_as_processor
    create_list(:tracking_task, 30, worker: @me)
	end

  after(:each) do
    Warden.test_reset!
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
  end

  scenario "Only see 20 jobs at a time" do
    visit root_path

    j = Job.last

    expect(page).not_to have_link j.file_number, href: job_path(j)
  end

  scenario "next button shows next group of jobs" do
    visit root_path

    click_on "Next"
    j = Job.last

    expect(page).to have_link j.file_number, href: job_path(j)
  end
end
