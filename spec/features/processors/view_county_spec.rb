include Warden::Test::Helpers
Warden.test_mode!

feature 'View County' do

	before(:each) do
    @client = create(:client)
    @state = create(:state)
    @county = create(:county, state: @state)
    create_list(:job, 30, county: @county)
		sign_in_as_processor
		visit state_county_path(@state, @county)
	end

  after(:each) do
    Warden.test_reset!
  end

	scenario 'shows only 20 jobs' do
    lj = @county.jobs.last
    j = @county.jobs.first
    expect(page).to have_link(j.file_number, href: job_path(j))
    expect(page).not_to have_link(lj.file_number, href: job_path(lj))
	end

	scenario 'clicking next shows next jobs' do
    click_on 'Next'
    j = @county.jobs.last
    expect(page).to have_link(j.file_number, href: job_path(j))
	end
end
