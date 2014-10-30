class Report
  include ActiveAttr::Model
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
    job_products = self.client.jobs.map{|j| j.job_products_cleared_between(start_on, end_on)}.flatten
    if self.lender_id.present?
      logger.debug "----------> Lender id: #{self.lender_id} <-----------"
      job_products = job_products.select{|jp| jp if jp.lender_id == self.lender_id}
    end
    job_products
  end

end
