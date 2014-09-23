module RelatedCountyState
	extend ActiveSupport::Concern

	included do
		belongs_to :county
		belongs_to :state
		validates :county, presence: true
		validates :state, presence: true
	end

end