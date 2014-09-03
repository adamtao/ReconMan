namespace :zipcodes do

	desc "Loads the CSV zipcodes into the application database"
	task load: :environment do
		Zipcode.import_from_csv(Rails.root.join('db', 'zip_code_database.csv'))
	end

end