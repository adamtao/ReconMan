class Job < ActiveRecord::Base
	include Workflow
	workflow do
		state :new do
			event :search, :transitions_to => :open
		end
		state :open do
			event :change_in_cached_response, :transitions_to => :needs_review
			event :mark_complete, :transitions_to => :complete
		end
		state :needs_review do 
			event :mark_complete, :transitions_to => :complete
		end
		state :complete
		state :canceled
	end

	belongs_to :client
	belongs_to :county
	has_many :title_search_caches

end
