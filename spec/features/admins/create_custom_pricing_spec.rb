include Warden::Test::Helpers
Warden.test_mode!

# Feature: Admin creates client-specific product pricing
#   As an admin user
#   I want to create client product pricing
#   So clients can be charged differently
feature 'Create client product', :devise do

	before(:each) do
    @product = create(:product, price_cents: 19995)
    @client = create(:client)

		sign_in_as_admin
	end

  after(:each) do
    Warden.test_reset!
  end

  # Scenario: Admin creates a custom price for a client
  #   Given I am an admin and signed in
  #   When I fill out the custom price form
  #   Then I should see the custom price on the client page
  scenario 'valid client product price created' do
    visit client_path(@client)

    click_on '$199.95'
    fill_in 'Price', with: '29.98'
    click_on 'Save Custom Price'

    expect(page).to have_content('$29.98')
  end

end
