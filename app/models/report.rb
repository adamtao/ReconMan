class Report
  include ActiveAttr::Model

  attribute :job_status, default: 'complete'
  attribute :client_id, type: Integer
  attribute :lender_id, type: Integer
  attribute :start_on, type: Date
  attribute :end_on, type: Date
  attribute :show_pricing, type: Boolean, default: false
  attribute :total_cents, type: Integer

  validates :client_id, presence: true
  validates :start_on, presence: true
  validates :end_on, presence: true

  def client
    @client ||= (self.client_id && self.client_id > 0) ?
      Client.find(self.client_id) :
      false
  end

  #TODO: Refactor the job select for reports. Using Job.all is a bad idea.
  def jobs
    @jobs ||= self.client ? self.client.jobs : Job.all
  end

  def job_products
    @job_products ||= gather_job_products
  end

  def gather_job_products
    self.job_status = 'complete' if self.job_status.blank?
    job_products = self.jobs.map{|j| j.job_products_for_report_between(start_on, end_on, job_status)}.flatten
    if self.lender_id.present? && self.lender_id > 0
      job_products = job_products.select{|jp| jp if jp.lender_id == self.lender_id}
    end
    job_products
  end

  def title
    words = []
    words << self.job_status.titleize if self.job_status
    words << "Jobs For"
    words << self.client.name if self.client
    if self.start_on
      words << "From"
      words << self.start_on.to_s
    end
    if self.end_on
      words << "Through"
      words << self.end_on.to_s
    end
    words.join(" ")
  end

  def total
    @total ||= Money.new(
      self.job_products.inject(0){|t,jp| t += jp.price},
      "USD"
    )
  end
end
