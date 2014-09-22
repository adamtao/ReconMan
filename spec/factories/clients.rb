# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client do
    sequence(:name) {|c| "Client ##{c}"}
		# client_type
		# website
		# billing_address
		# billing_city
		# billing_state_id
		# billing_zipcode
		# created_by_id
		# modified_by_id
  end
end
