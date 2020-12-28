require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Processor adds task to existing job', :devise do
  before :each do
    @task = create(:tracking_task, deed_of_trust_number: "ABC12345")
    @job = @task.job

		sign_in_as_processor
		visit job_path(@job)
	end

  after(:each) do
    Warden.test_reset!
  end

  scenario "successfully", js: true do
    click_on 'Add product/service'
    select @task.product.name, from: 'Product'
    fill_in 'Deed of trust number', with: "DOT12345"
    fill_in 'Beneficiary Account', with: "BA5678"
    fill_in 'Payoff Amount', with: "125000.00"
    select Lender.first.name, from: 'Lender'
    click_on 'Create Task'

    expect(page).to have_content("DOT12345")
    expect(page).to have_content("BA5678")
  end

end
