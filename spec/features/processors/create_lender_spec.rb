require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Create lender
#   As a processor
#   I want to create a lender
#   So I can add that lender to a job
feature "Create lender", :devise do
  before(:each) do
    sign_in_as_processor
  end

  after(:each) do
    Warden.test_reset!
  end

  scenario 'successfully' do
    visit new_lender_path

    fill_in 'Name', with: "Something Cool"
    click_on "Create Lender"

    expect(page).to have_css("h1", text: "Something Cool")
  end
end

# Feature: Create a lender inline
#   As a processor
#   I want to create a new lender when creating a job
#   So that I can create more jobs quickly
feature "Create lender inline", :devise do
  before :all do
    @client = FactoryGirl.create(:client)
    @branch = FactoryGirl.create(:branch, client: @client)
    @employee = FactoryGirl.create(:user, branch: @branch)
    @tracking_job = FactoryGirl.create(:tracking_job, client: @client, requestor: @employee)
  end

  before :each do
    sign_in_as_processor
  end

  after(:each) do
    Warden.test_reset!
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
  end

  # Scenario: visit new job form, create lender inline
  #   Given I am a logged-in processor
  #   When I visit the new job form and select a tracking job
  #   And I fill out the new lender section
  #   Then the new lender is created and associated with the tracking job product
  scenario "on the new job form" do
    new_tj = FactoryGirl.attributes_for(:tracking_job)
    new_tjp = FactoryGirl.attributes_for(:tracking_task)
    lender = FactoryGirl.attributes_for(:lender)
    visit client_path(@tracking_job.client)

    within("ul#job-types") do
      click_on "Tracking"
    end

    fill_in "File number", with: new_tj[:file_number]
    fill_in "Close Date", with: 1.week.from_now.to_date
    select @tracking_job.client.name, from: "Client"
    select @tracking_job.requestor.name, from: "Requestor"
    fill_in "Address", with: new_tj[:address]
    fill_in "Zipcode", with: new_tj[:zipcode]
    fill_in "City", with: new_tj[:city]
    select @tracking_job.state.name, from: "State"
    select @tracking_job.county.name, from: "County"
    fill_in "Buyer", with: new_tj[:buyer]
    fill_in "Seller", with: new_tj[:seller]
    fill_in "Deed of trust number", with: new_tjp[:deed_of_trust_number]
    select "", from: "Lender"
    fill_in "Beneficiary Account", with: new_tjp[:beneficiary_account]
    fill_in "Payoff Amount", with: new_tjp[:payoff_amount_cents].to_i / 100

    #click_on "New lender"
    fill_in "New Lender Name", with: lender[:name]
    click_on "Create Job"

    expect(page).to have_content(lender[:name])
  end

  # Scenario: visit existing job, add a tracking job product and a new lender
  #   Given I am a logged-in processor
  #   When I add a product to an existing job
  #   I can fill out the new lender portion
  #   Then I expect the new lender to be created and associated with the new job product
  scenario "on the new job product form" do
    new_tjp = FactoryGirl.attributes_for(:tracking_product)
    lender = FactoryGirl.attributes_for(:lender)
    visit job_path(@tracking_job)
    click_on "Add product"

    select Product.first.name, from: "Product"
    select @employee.name, from: "Worker"
    fill_in "Deed of trust number", with: new_tjp[:deed_of_trust_number]
    fill_in "Beneficiary Account", with: "76543"
    fill_in "Payoff Amount", with: "3408.23"
    fill_in "New Lender Name", with: lender[:name]
    click_on "Create Task"

    expect(page).to have_content(lender[:name])
    expect(Lender.last.name).to eq(lender[:name])
  end
end

feature "Edit lender", :devise do
  before :all do
    @lender = FactoryGirl.create(:lender, name: "Mr. Foo's Lending")
  end

  before(:each) do
    sign_in_as_processor
    visit lender_path(@lender)
  end

  after(:each) do
    Warden.test_reset!
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
  end

  scenario "Visiting a lender should have an edit button" do
    expect(page).to have_link("Edit Lender", href: edit_lender_path(@lender))
  end

  scenario "Edit button should take you to working lender edit form" do
    click_on "Edit Lender"
    fill_in "Name", with: "Mr. Goo's Lending"
    click_on "Update Lender"

    expect(page).to have_content("Mr. Goo's Lending")
    expect(page).not_to have_content("Mr. Foo's Lending")
  end
end
