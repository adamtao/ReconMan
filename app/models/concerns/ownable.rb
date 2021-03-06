module Ownable
	extend ActiveSupport::Concern

	included do
		belongs_to :creator, class_name: "User", foreign_key: :created_by_id
		belongs_to :modifier, class_name: "User", foreign_key: :modified_by_id
	end

	def is_ownable?
		true
	end
end