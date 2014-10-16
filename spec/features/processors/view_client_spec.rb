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
    expect(page).to have_css('table#incomplete-jobs tbody tr', count: 20)
    expect(page).to have_link("Next")
	end

	scenario 'clicking next shows next jobs' do
    j = @client.jobs.last

    click_on 'Next'

    expect(page).to have_link(j.file_number, href: job_path(j))
	end
end
