include Warden::Test::Helpers
Warden.test_mode!

feature 'View client' do

	before(:each) do
    @client = create(:client)
    create_list(:job, 30, client: @client)
		sign_in_as_processor
		visit client_path(@client)
	end

  after(:each) do
    Warden.test_reset!
  end

	scenario 'shows only 20 jobs' do
    lj = @client.jobs.last
    j = @client.jobs.first
    expect(page).to have_link(j.file_number, href: job_path(j))
    expect(page).not_to have_link(lj.file_number, href: job_path(lj))
	end

	scenario 'clicking next shows next jobs' do
    click_on 'Next'
    j = @client.jobs.last
    expect(page).to have_link(j.file_number, href: job_path(j))
	end
end
