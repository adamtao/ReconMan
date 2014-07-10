# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html

puts 'CREATING DEFAULT PRODUCTS & SERVICES'

Product.create([
	{ name: "Reconveyance Tracking", price: 19.95 },
	{ name: "Title Defect Clearing", price: 19.95 },
	{ name: "Documentation", price: 19.95 }
])

State.create([
  { :name => 'Alabama', :abbreviation => 'AL'},
  { :name => 'Alaska', :abbreviation => 'AK'},
  { :name => 'Arizona', :abbreviation => 'AZ'},
  { :name => 'Arkansas', :abbreviation => 'AR'},
  { :name => 'California', :abbreviation => 'CA'},
  { :name => 'Colorado', :abbreviation => 'CO'},
  { :name => 'Connecticut', :abbreviation => 'CT'},
  { :name => 'Delaware', :abbreviation => 'DE'},
  { :name => 'District of Columbia', :abbreviation => 'DC'},
  { :name => 'Florida', :abbreviation => 'FL'},
  { :name => 'Georgia', :abbreviation => 'GA'},
  { :name => 'Hawaii', :abbreviation => 'HI'},
  { :name => 'Idaho', :abbreviation => 'ID'},
  { :name => 'Illinois', :abbreviation => 'IL'},
  { :name => 'Indiana', :abbreviation => 'IN'},
  { :name => 'Iowa', :abbreviation => 'IA'},
  { :name => 'Kansas', :abbreviation => 'KS'},
  { :name => 'Kentucky', :abbreviation => 'KY'},
  { :name => 'Louisiana', :abbreviation => 'LA'},
  { :name => 'Maine', :abbreviation => 'ME'},
  { :name => 'Maryland', :abbreviation => 'MD'},
  { :name => 'Massachusetts', :abbreviation => 'MA'},
  { :name => 'Michigan', :abbreviation => 'MI'},
  { :name => 'Minnesota', :abbreviation => 'MN'},
  { :name => 'Mississippi', :abbreviation => 'MS'},
  { :name => 'Missouri', :abbreviation => 'MO'},
  { :name => 'Montana', :abbreviation => 'MT'},
  { :name => 'Nebraska', :abbreviation => 'NE'},
  { :name => 'Nevada', :abbreviation => 'NV'},
  { :name => 'New Hampshire', :abbreviation => 'NH'},
  { :name => 'New Jersey', :abbreviation => 'NJ'},
  { :name => 'New Mexico', :abbreviation => 'NM'},
  { :name => 'New York', :abbreviation => 'NY'},
  { :name => 'North Carolina', :abbreviation => 'NC'},
  { :name => 'North Dakota', :abbreviation => 'ND'},
  { :name => 'Ohio', :abbreviation => 'OH'},
  { :name => 'Oklahoma', :abbreviation => 'OK'},
  { :name => 'Oregon', :abbreviation => 'OR'},
  { :name => 'Pennsylvania', :abbreviation => 'PA'},
  { :name => 'Rhode Island', :abbreviation => 'RI'},
  { :name => 'South Carolina', :abbreviation => 'SC'},
  { :name => 'South Dakota', :abbreviation => 'SD'},
  { :name => 'Tennessee', :abbreviation => 'TN'},
  { :name => 'Texas', :abbreviation => 'TX'},
  { :name => 'Utah', :abbreviation => 'UT'},
  { :name => 'Vermont', :abbreviation => 'VT'},
  { :name => 'Virginia', :abbreviation => 'VA'},
  { :name => 'Washington', :abbreviation => 'WA'},
  { :name => 'West Virginia', :abbreviation => 'WV'},
  { :name => 'Wisconsin', :abbreviation => 'WI'},
  { :name => 'Wyoming', :abbreviation => 'WY'}
])