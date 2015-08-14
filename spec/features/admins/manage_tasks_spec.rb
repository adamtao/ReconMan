require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Admin manages tasks for a given job
#   As an admin user
#   I want to add/edit/remove products on a job
#   So that processors can perform the work
feature 'Manage tasks', :devise do

	before(:all) do
    @tracking_task = FactoryGirl.create(:tracking_task, deed_of_trust_number: "ABC12345")
  end

  before :each do
		sign_in_as_admin
    visit job_path(@tracking_task.job)
	end

  after(:each) do
    Warden.test_reset!
  end

  # Scenario: Admin deletes a product from a job
  #   Given I am logged in administrator
  #   When I visit a job page and click on a task delete button
  #   Then that task should be deleted
  scenario 'delete a task' do
    click_on "Delete #{@tracking_task.name}"

    expect(page).not_to have_content(@tracking_task.deed_of_trust_number)
    expect(Task.exists?(@tracking_task.id)).to be(false)
  end

  # Scenario: Admin edits a task details
  #   Given I am a logged in administrator
  #   When I edit a task
  #   Then those changes appear on the job page
  scenario "edit a task" do
    click_on "Edit #{@tracking_task.name}"

    fill_in "Deed of trust number", with: "XYZ999"
    click_on "Update Tracking task"

    expect(page).to have_content("XYZ999")
  end

  # Scenario: Admin adds a task to a job
  #   Given I am a logged in administrator
  #   When I complete the form to add a product to a job
  #   Then it appears on the job page
  scenario "admin adds a product to a job" do
    np = FactoryGirl.attributes_for(:task, deed_of_trust_number: "YOMAMA")
    click_on "Add product"

    select @tracking_task.product.name, from: "Product"
    select @tracking_task.worker.name, from: "Worker"
    fill_in "Deed of trust number", with: np[:deed_of_trust_number]
    select @tracking_task.lender.name, from: "Lender"
    fill_in "Beneficiary Account", with: "76543"
    fill_in "Payoff Amount", with: "3408.23"
    click_on "Create Task"

    expect(page).to have_content(np[:deed_of_trust_number])
  end
end
