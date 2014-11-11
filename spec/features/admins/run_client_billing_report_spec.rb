require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature "Admin runs monthly report for client" do

  before do
    @job_product = FactoryGirl.create(:tracking_job_product,
      workflow_state: 'complete',
      deed_of_trust_number: "1234",
      new_deed_of_trust_number: "5678",
      cleared_on: 2.weeks.ago,
      recorded_on: 2.weeks.ago
    )
    @job_product.job.update_column(:file_number, "foobar45")
    @client = @job_product.job.client
    @incomplete_job = FactoryGirl.create(:tracking_job, client: @client, file_number: "9999")
    other_client = FactoryGirl.create(:client)
    @other_job = FactoryGirl.create(:tracking_job, client: other_client, file_number: "8888")
    sign_in_as_admin
    visit root_path
  end

  after(:each) do
    Warden.test_reset!
  end

  # As an admin
  # I want to run reports
  # So that I can perform billing, etc.
  scenario "successfully" do
    click_on 'Reports'
    fill_in_basic_fields
    click_on 'Run Report'

    expect(page).to have_content("Complete Jobs For #{@client.name}")
    expect(page).to have_css('table#jobs tr td', text: @job_product.job.file_number)
    expect(page).to have_css('table#jobs tr td', text: @job_product.deed_of_trust_number)
    expect(page).not_to have_content(@other_job.file_number)
    expect(page).not_to have_content(@incomplete_job.file_number)
  end

  # As an admin
  # I want to filter reports by lender
  # So that I can let clients know how lenders are performing
  scenario "filtered by lender successfully" do
    new_job = FactoryGirl.create(:tracking_job, client: @client, file_number: "9999b")
    new_job.reload
    lender = FactoryGirl.create(:lender)
    jp = new_job.job_products.first
    jp.update_column(:lender_id, lender.id)
    jp.mark_complete!
    jp.update_column(:cleared_on, 5.days.ago)

    click_on 'Reports'
    fill_in_basic_fields
    select lender.name, from: 'Lender'
    click_on 'Run Report'

    expect(page).not_to have_content(@job_product.lender.name)
    expect(page).to have_content(lender.name)
  end

  # As an admin
  # I want to filter reports by pending jobs
  # So I can show clients what is happening with open jobs
  scenario "filtered by job status (pending)" do
    new_job = FactoryGirl.create(:tracking_job, client: @client, file_number: "9999p")
    new_job.reload
    jp = new_job.job_products.first
    jp.update_column(:workflow_state, "in_progress")

    click_on 'Reports'
    fill_in_basic_fields
    select "In Progress", from: "Job status"
    click_on "Run Report"

    expect(page).not_to have_css('table#jobs tr td', text: @job_product.job.file_number)
    expect(page).to have_css('table#jobs tr td', text: jp.job.file_number)
    expect(page).to have_content "In Progress Jobs For"
  end

  # As an admin
  # I want to run reports without separating by client
  # So that I can get a big picture of the business performance
  scenario "unfiltered by client" do
    click_on 'Reports'
    fill_in 'Start on', with: 1.month.ago
    fill_in 'End on', with: 1.day.from_now
    click_on "Run Report"

    expect(page).to have_css('table#jobs tr td', text: @job_product.job.file_number)
    expect(page).to have_css('table#jobs tr td', text: @job_product.deed_of_trust_number)
  end

  # As an admin
  # I want to run reports with pricing columns
  # So I can collect money for those jobs or see how much money is pending
  scenario "with pricing" do
    click_on 'Reports'
    fill_in_basic_fields
    check "Show pricing"
    click_on "Run Report"

    expect(page).to have_content(@job_product.price)
    expect(page).to have_content("Total")
  end

  # As an admin
  # I want to mark all reported jobs as billed
  # So I can keep track of which jobs have been billed to the customer
  scenario "marking jobs as billed" do
    click_on 'Reports'
    fill_in_basic_fields
    click_on "Run Report"

    click_on "Mark All As Billed"
    @job_product.reload

    expect(page).to have_content("All the following jobs have been marked as billed.")
    expect(@job_product.billed?).to eq(true)
  end

  # As an admin
  # I want to exclude already billed jobs from reports
  # So I don't double-bill a client
  scenario "exclude already billed jobs" do
    billed_job_product = FactoryGirl.create(
      :tracking_job_product,
      cleared_on: 1.week.ago,
      workflow_state: 'complete',
      billed: true,
      deed_of_trust_number: "billed_job_123",
      job_id: @job_product.job_id
    )

    click_on 'Reports'
    fill_in_basic_fields
    check 'Exclude billed'

    expect(page).not_to have_content(billed_job_product.deed_of_trust_number)
  end

  def fill_in_basic_fields
    select @client.name, from: 'Client'
    fill_in 'Start on', with: 1.month.ago
    fill_in 'End on', with: 1.day.from_now
  end
end
