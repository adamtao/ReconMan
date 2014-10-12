class County < ActiveRecord::Base
	belongs_to :state
	has_many :jobs

  validates :state, presence: true
	validates :name, presence: true, uniqueness: { scope: :state }

	def offline_search?
		!self.search_url.present?
	end

  def current_jobs
    jobs.where.not(workflow_state: "complete") #.joins(:job_products).order("job_products.due_on DESC")
  end

	def calculate_days_to_complete!
		j = jobs.where(job_type: 'tracking', workflow_state: 'complete').limit(100).order("created_at DESC")
		t = 0
		c = 0
		if j.length > 10
			j.each do |job|
        job.job_products.each do |jp|
          if jp.product.performs_search? && jp.recorded_on.present?
            diff = (jp.recorded_on.to_date - job.close_on.to_date)
            if diff > 0
              t += diff
              c += 1
            end
          end
        end
      end
			if c > 0
        self.average_days_to_complete = (t / c).to_i
        self.save
			end
		end
	end
end
