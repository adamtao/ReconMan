# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :state do
    sequence(:name) {|s| "State #{s}"}
    sequence(:abbreviation) {|a| "S#{a}"}
		time_to_record_days 30
		active true
		time_to_notify_days 30
		time_to_dispute_days 30 
		can_force_reconveyance true
		allow_sub_of_trustee true
		record_reconveyance_request true
  end
end
