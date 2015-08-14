# Directly modeled after the zipcode database here:
#
#  http://www.unitedstateszipcodes.org/zip-code-database/
#
# There is some duplication between this model and the
# State and County models. I decided to do it this way
# so that if a new database becomes available, I could
# import it here without affecting anything else.
#
# The intention of this database is to auto-fill the city,
# state, and county fields for a new job based on the
# zipcode.
#
require 'csv'
class Zipcode < ActiveRecord::Base

	def self.lookup(zipcode)
		find_by(zipcode: zipcode)
	end

	def lookup_state
		@state ||= State.find_by(abbreviation: self.state)
	end

	def lookup_county
    t = County.arel_table
    @county ||= County.where(state: state_id).where(t[:name].matches("%#{county.gsub(/\s?County$/i, '')}")).first
	end

	def state_id
    @state_id ||= lookup_state.is_a?(State) ? lookup_state.id : nil
	end

	def county_id
    @county_id ||= lookup_county.is_a?(County) ? lookup_county.id : nil
	end

	def self.import_from_csv(csv_file_path)
		self.delete_all
		CSV.foreach(csv_file_path, headers: true) { |z| create z.to_hash }
	end

	# zip setter for compatibility with CSV import
	def zip=(db_zip)
		self.zipcode = db_zip
	end

	# type setter for compatibility with CSV import
	def type=(db_type)
		self.zip_type = db_type
	end
end
