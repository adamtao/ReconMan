# Feature: Admin creates products
#   As an admin user
#   I want create products
#   So processors can add them to jobs
feature 'Create product' do

	before(:each) do
		sign_in_as_admin
	end

  # Scenario: Admin creates the default tracking product
  #   Given I am and admin signed in
  #   When I create a product as a tracking job_type
  #   Then I should see the product in the list
  scenario 'default tracking product created'

  # Scenario: Admin creates the default search product
  #   Given I am and admin signed in
  #   When I create a product as a search job_type
  #   Then I should see the product in the list
  scenario 'default search product created'

  # Scenario: Admin creates the default special product
  #   Given I am and admin signed in
  #   When I create a product as a special job_type
  #   Then I should see the product in the list
  scenario 'default special product created'

  scenario 'invalid product created'

end