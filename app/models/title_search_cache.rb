class TitleSearchCache < ActiveRecord::Base
	belongs_to :job_product
	belongs_to :job, through: :job_product
end
