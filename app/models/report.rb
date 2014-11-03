class Report
  include ActiveAttr::Model
  include ActiveAttr::AttributeDefaults

  attribute :job_status, default: 'complete'
  attribute :client_id
  attribute :lender_id
  attribute :start_on
  attribute :end_on

  validates :client_id, presence: true
  validates :start_on, presence: true
  validates :end_on, presence: true

  def client
    @client ||= Client.find(self.client_id)
  end

  def job_products
    @job_products ||= gather_job_products
  end

  def gather_job_products
    self.job_status = 'complete' if self.job_status.blank?
    job_products = self.client.jobs.map{|j| j.job_products_for_report_between(start_on, end_on, job_status)}.flatten
    if self.lender_id.present?
      job_products = job_products.select{|jp| jp if jp.lender_id.to_i == self.lender_id.to_i}
    end
    job_products
  end

end
