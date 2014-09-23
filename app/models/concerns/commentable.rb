module Commentable
	extend ActiveSupport::Concern

	included do
		has_many :comments, -> (owner) { where(related_type: owner.class.name) }, foreign_key: "related_id"
	end

end