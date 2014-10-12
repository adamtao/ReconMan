include Warden::Test::Helpers
Warden.test_mode!

feature 'View user' do

	before(:each) do
    @client = create(:client)
    @branch = create(:branch, client: @client)
    @employee = create(:user, :client,
                       branch: @branch)
    create_list(:tracking_job, 30, client: @client,
                requestor: @employee)
    @first_job = @employee.current_requested_jobs.first
    @last_job = @employee.current_requested_jobs.last
    @processor = @first_job.job_products.first.worker
		sign_in_as_admin
	end

  after(:each) do
    Warden.test_reset!
  end

	scenario 'shows only 20 jobs on the requestor page' do
		visit user_path(@employee)
    expect(page).to have_link(@first_job.file_number, href: job_path(@first_job))
    expect(page).not_to have_link(@last_job.file_number, href: job_path(@last_job))
    expect(page).to have_link("Next")
	end

	scenario 'shows only 20 jobs on the processor page' do
		visit user_path(@processor)
    expect(page).to have_link(@first_job.file_number, href: job_path(@first_job))
    expect(page).not_to have_link(@last_job.file_number, href: job_path(@last_job))
    expect(page).to have_link("Next")
	end

end
