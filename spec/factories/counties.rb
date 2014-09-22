# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :county do
    name "MyString"
    state
    search_url "MyString"
    search_params "MyString"
    search_method "MyString"
    average_days_to_complete "MyString"
		# phone
		# fax
		# webpage
		# contact_name
		# contact_phone
		# contact_email
		# assessor_webpage
		# zip_codes
		# co_fee_schedule
		# simplifile
		# s_contact_name
		# s_contact_phone
		# s_contact_email
  end
end
