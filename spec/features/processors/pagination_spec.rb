include Warden::Test::Helpers
Warden.test_mode!

feature 'Pagination' do

	before(:each) do
		@me = sign_in_as_processor
		@tracking_product = create(:tracking_product)
		@search_product = create(:search_product)
		@special_product = create(:special_product)
    create_list(:tracking_job_product, 30, worker: @me)
	end

  after(:each) do
    Warden.test_reset!
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
