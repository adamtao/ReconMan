require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Admin creates products
#   As an admin user
#   I want create products
#   So processors can add them to jobs
feature 'Create product' do

	before(:each) do
		sign_in_as_admin
	end

  after(:each) do
    Warden.test_reset!
  end

  # Scenario: Admin creates the default tracking product
  #   Given I am and admin signed in
  #   When I create a product as a tracking job_type
  #   Then I should see the product in the list
  scenario 'default tracking product created' do
    visit new_product_path

    fill_in 'Name', with: 'Tracking Product'
    select 'Tracking', from: 'product_job_type'
    click_on 'Create Product'

    expect(page).to have_content('Tracking Product')
  end

  # Scenario: Admin creates the default search product
  #   Given I am and admin signed in
  #   When I create a product as a search job_type
  #   Then I should see the product in the list
  scenario 'default search product created' do
    visit new_product_path

    fill_in 'Name', with: 'Search Product'
    select 'Search', from: 'product_job_type'
    click_on 'Create Product'

    expect(page).to have_content('Search Product')
  end

  # Scenario: Admin creates the default special product
  #   Given I am and admin signed in
  #   When I create a product as a special job_type
  #   Then I should see the product in the list
  scenario 'default special product created' do
    visit new_product_path

    fill_in 'Name', with: 'Special Product'
    select 'Special', from: 'product_job_type'
    click_on 'Create Product'

    expect(page).to have_content('Special Product')
  end

end
