class TitleSearchCache < ActiveRecord::Base
	belongs_to :job_product

	after_create :send_changed_response_alert

	# TODO: write method to alert regarding changed search results
	def send_changed_response_alert
		if self.change_detected?
			# Send alert!
		end
	end

	# TODO: write change detection method
	def change_detected?
		false
	end
end
