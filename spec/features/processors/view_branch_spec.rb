include Warden::Test::Helpers
Warden.test_mode!

feature 'View branch' do

	before(:each) do
    @client = create(:client)
    @branch = create(:branch, client: @client)
    @employee = create(:user, :client,
                       branch: @branch)
    create_list(:job, 30, client: @client,
                requestor: @employee)
		sign_in_as_processor
		visit client_branch_path(@client, @branch)
	end

  after(:each) do
    Warden.test_reset!
  end

	scenario 'shows only 20 jobs' do
    lj = @branch.jobs.last
    j = @branch.jobs.first
    expect(page).to have_link(j.file_number, href: job_path(j))
    expect(page).not_to have_link(lj.file_number, href: job_path(lj))
	end

	scenario 'clicking next shows next jobs' do
    click_on 'Next'
    j = @branch.jobs.last
    expect(page).to have_link(j.file_number, href: job_path(j))
	end
end
