require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Admin manages job_products for a given job
#   As an admin user
#   I want to add/edit/remove products on a job
#   So that processors can perform the work
feature 'Manage job products', :devise do

	before(:each) do
    @tracking_job_product = FactoryGirl.create(:tracking_job_product, deed_of_trust_number: "ABC12345")

		sign_in_as_admin
    visit job_path(@tracking_job_product.job)
	end

  after(:each) do
    Warden.test_reset!
  end

  # Scenario: Admin deletes a product from a job
  #   Given I am logged in administrator
  #   When I visit a job page and click on a job-product delete button
  #   Then that job-product should be deleted
  scenario 'delete a job product' do
    click_on "Delete #{@tracking_job_product.name}"

    expect(page).not_to have_content(@tracking_job_product.deed_of_trust_number)
    expect(JobProduct.exists?(@tracking_job_product.id)).to be(false)
  end

  # Scenario: Admin edits a job product details
  #   Given I am a logged in administrator
  #   When I edit a job product
  #   Then those changes appear on the job page
  scenario "edit a job product" do
    click_on "Edit #{@tracking_job_product.name}"

    fill_in "Deed of trust number", with: "XYZ999"
    click_on "Update Job product"

    expect(page).to have_content("XYZ999")
  end

  # Scenario: Admin adds a job_product to a job
  #   Given I am a logged in administrator
  #   When I complete the form to add a product to a job
  #   Then it appears on the job page
  scenario "admin adds a product to a job" do
    np = FactoryGirl.attributes_for(:job_product, deed_of_trust_number: "YOMAMA")
    click_on "Add product"

    select @tracking_job_product.product.name, from: "Product"
    select @tracking_job_product.worker.name, from: "Worker"
    fill_in "Deed of trust number", with: np[:deed_of_trust_number]
    select @tracking_job_product.lender.name, from: "Lender"
    fill_in "Beneficiary Account", with: "76543"
    fill_in "Payoff Amount", with: "3408.23"
    click_on "Create Job product"

    expect(page).to have_content(np[:deed_of_trust_number])
  end
end
