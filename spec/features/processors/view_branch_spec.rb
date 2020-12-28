require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'View branch' do

	before(:all) do
    @client = create(:client)
    @branch = create(:branch, client: @client)
    @employee = create(:user, :client,
                       branch: @branch)
    create_list(:job, 30, client: @client,
                requestor: @employee)
  end

  before :each do
		sign_in_as_processor
		visit client_branch_path(@client, @branch)
	end

  after(:each) do
    Warden.test_reset!
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
  end

	scenario 'shows only 20 jobs' do
    expect(page).to have_css('table#incomplete-jobs tbody tr', count: 20)
    expect(page).to have_link("Next")
	end

	scenario 'clicking next shows next jobs' do
    j = @branch.current_jobs.last

    #save_and_open_page
    click_on 'Next'
    #save_and_open_page

    expect(page).to have_link(j.file_number, href: job_path(j))
	end
end
