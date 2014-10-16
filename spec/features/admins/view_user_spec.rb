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

		sign_in_as_admin
	end

  after(:each) do
    Warden.test_reset!
  end

	scenario 'shows only 20 jobs on the requestor page' do
		visit user_path(@employee)

    expect(page).to have_css('table#incomplete-jobs tbody tr', count: 20)
    expect(page).to have_link("Next")
	end

	scenario 'shows only 20 jobs on the processor page' do
    first_job = @employee.current_requested_jobs.first
    @processor = first_job.job_products.first.worker

		visit user_path(@processor)

    expect(page).to have_css('table#incomplete-jobs tbody tr', count: 20)
    expect(page).to have_link("Next")
	end

end
