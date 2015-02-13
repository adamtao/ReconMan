class Lender < ActiveRecord::Base
  has_many :tasks

  validates :name, presence: true, uniqueness: true

  def merge_with!(other_lender)
    other_lender.tasks.update_all(lender_id: self.id)
    other_lender.destroy
  end

	def calculate_days_to_complete!
    jps = tasks.joins(:job).where(workflow_state: 'complete').where.not("jobs.close_on is null").limit(100).order("created_at DESC")
		t = 0
		c = 0
		if jps.length > 10
			jps.each do |jp|
        if jp.product.performs_search? && jp.recorded_on.present?
          diff = (jp.recorded_on.to_date - jp.job.close_on.to_date)
          if diff > 0
            t += diff
            c += 1
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
