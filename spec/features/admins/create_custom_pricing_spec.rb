# Feature: Admin creates client-specific product pricing
#   As an admin user
#   I want create client product pricing
#   So clients can be charged differently
feature 'Create client product' do

	before(:each) do
		sign_in_as_admin
	end

  scenario 'valid client product price created'

  scenario 'invalid client product price created'

end