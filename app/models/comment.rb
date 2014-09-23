class Comment < ActiveRecord::Base
	belongs_to :user

	validates :message, presence: true
	validates :user, presence: true
	validates :related_id, presence: true
	validates :related_type, presence: true

	def related
		self.related_type.classify.constantize.send(:find, self.related_id)
	end
end
