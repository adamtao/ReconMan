class Report
  include ActiveAttr::Model

  attribute :job_status, default: 'complete'
  attribute :client_id, type: Integer
  attribute :lender_id, type: Integer
  attribute :start_on, type: Date
  attribute :end_on, type: Date
  attribute :exclude_billed, type: Boolean, default: true
  attribute :show_pricing, type: Boolean, default: false
  attribute :total_cents, type: Integer

  validates :client_id, presence: true
  validates :start_on, presence: true
  validates :end_on, presence: true

  def client
    @client ||= lookup_related(Client)
  end

  def lender
    @lender ||= lookup_related(Lender)
  end

  #TODO: Refactor the job select for reports. Using Job.all is a bad idea.
  def jobs
    @jobs ||= self.client ? self.client.jobs : Job.all
  end

  def tasks
    @tasks ||= gather_tasks
  end

  def gather_tasks
    self.job_status = 'complete' if self.job_status.blank?
    tasks = self.jobs.map{|j| j.tasks_for_report_between(start_on, end_on, job_status, exclude_billed)}.flatten
    if self.lender
      tasks = tasks.select{|jp| jp if jp.lender_id == self.lender_id}
    end
    tasks
  end

  # Sets the billed? flag to true on each of the matching tasks
  def mark_all_billed!
    Task.where(id: self.tasks.map{|jp| jp.id}).update_all(billed: true)
  end

  def title
    words = []
    words << self.job_status.titleize if self.job_status
    words << "Jobs"
    if self.client
      words << "For"
      words << self.client.name
    end
    words.join(" ")
  end

  def subtitle
    words = []
    if self.lender
      words << "For Lender:"
      words << self.lender.name
    end
    if self.job_status == 'Complete'
      if self.start_on
        words << "From"
        words << self.start_on.to_s
      end
      if self.end_on
        words << "Through"
        words << self.end_on.to_s
      end
    else
      words << "as of"
      words << Date.today.to_s
    end
    words.join(" ")
  end

  def total
    @total ||= Money.new(
      self.tasks.inject(0){|t,jp| t += jp.price},
      "USD"
    )
  end

  # Array of labels for the report columns--used in both HTML and XLS outputs.
  def headers
    h = ["File Number", "County", "State", "Client", "Escrow Officer", "Close Date",
      "Lender", "DOT #", "Release #", "Release Date"]

    if self.job_status.match(/complete/i)
      h << "Branch"
    else
      h += ["1st Notice", "2nd Notice"]
    end

    h << "Price" if self.show_pricing?
    h
  end

  # Columns for the report's job products--used in both HTML and XLS outputs.
  def columns
    c = [:file_number, :county_name, :state_abbreviation, :client_name, :requestor_name,
         :close_date, :lender_name, :deed_of_trust_number, :new_deed_of_trust_number,
         :recorded_on]

    if self.job_status.match(/complete/i)
      c << :branch_name
    else
      c += [:first_notice_date, :second_notice_date]
    end

    c << :report_price if self.show_pricing?
    c
  end

  def to_xls
    self.tasks.to_xls(
      headers: headers,
      columns: columns
    )
  end

  private

  def lookup_related(klass)
    c_id = self.send("#{klass.name.parameterize}_id")
    c_id.present? && c_id > 0 ? klass.send(:find, c_id) : false
  end
end
