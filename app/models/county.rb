class County < ApplicationRecord
	belongs_to :state
	has_many :jobs, dependent: :nullify

  validates :state, presence: true
	validates :name, presence: true, uniqueness: { scope: :state }

  def self.checkout_inactivity_limit
    15.minutes
  end

  def self.needing_work
    timeout_checkouts!
    jobs_needing_work = Job.dashboard_jobs(limit: 9000, per_page: 9000)
    where(checked_out_at: nil).where(id: jobs_needing_work.pluck(:county_id))
  end

  def self.timeout_checkouts!
    where("checked_out_at < ?", checkout_inactivity_limit.ago).update_all(checked_out_at: nil, checked_out_to_id: nil)
  end

	def offline_search?
		!self.search_url.present?
	end

  def current_jobs(options={})
    if options[:included_job]
      cj = jobs.where("jobs.workflow_state != 'complete' OR jobs.id = ?", options[:included_job].id)
    else
      cj = jobs.where.not(workflow_state: "complete")
    end
    cj.joins("left outer join tasks on tasks.job_id = jobs.id").order("tasks.due_on ASC")
  end

  def next_job(job)
    job.next
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

  def destroy
    raise "Cannot delete a county with associated jobs." if jobs.count > 0
    super
  end

end
