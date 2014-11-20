class County < ActiveRecord::Base
	belongs_to :state
	has_many :jobs

  validates :state, presence: true
	validates :name, presence: true, uniqueness: { scope: :state }

  def self.checkout_inactivity_limit
    15.minutes
  end

  def self.needing_work
    timeout_checkouts!
    jobs_needing_work = Job.dashboard_jobs(limit: 2000, per_page: 2000)
    where(checked_out_at: nil).where(id: jobs_needing_work.pluck(:county_id))
  end

  def self.timeout_checkouts!
    where("checked_out_at < ?", checkout_inactivity_limit.ago).update_all(checked_out_at: nil, checked_out_to_id: nil)
  end

	def offline_search?
		!self.search_url.present?
	end

  def current_jobs
    jobs.where.not(workflow_state: "complete").joins("left outer join job_products on job_products.job_id = jobs.id").order("job_products.due_on DESC")
  end

  def next_job(job)
    pos = self.current_jobs.index(job)
    self.current_jobs.length > pos ? current_jobs[pos + 1] : false
  end

	def calculate_days_to_complete!
    j = jobs.where(job_type: 'tracking', workflow_state: 'complete').where.not(close_on: nil).limit(100).order("created_at DESC")
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

  def to_option
    "#{self.name}, #{self.state.abbreviation} (#{self.current_jobs.length})"
  end

  def checkout_to(user)
    if user.checked_out_county
      user.checked_out_county.expire_checkout!
    end
    update_attributes(checked_out_to_id: user.id, checked_out_at: Time.zone.now)
  end

  def checked_out?
    self.checked_out_at.present? && self.checked_out_at.to_time >= self.class.checkout_inactivity_limit.ago
  end

  def checked_out_to
    if (self.checked_out? && self.checked_out_to_id.present?)
      User.find(self.checked_out_to_id)
    else
      nil
    end
  end

  def renew_checkout
    self.update_column(:checked_out_at, Time.now)
  end

  def checkout_expired_for?(user)
    self.checked_out_to_id == user.id && !self.checked_out?
  end

  def expire_checkout!
    self.update_attributes(checked_out_to_id: nil, checked_out_at: nil)
  end
end
