class DocumentationTask < Task

  workflow do
    state :in_progress do
      event :order_docs, transitions_to: :docs_ordered
      event :deliver_docs, transitions_to: :docs_delivered
      event :file_reconveyance, transitions_to: :reconveyance_filed
      event :mark_complete, transitions_to: :complete
    end
    state :docs_ordered do
      event :deliver_docs, transitions_to: :docs_delivered
    end
    state :docs_delivered do
      event :file_reconveyance, transitions_to: :reconveyance_filed
    end
    state :reconveyance_filed do
      event :mark_complete, transitions_to: :complete
    end
    state :complete do
      event :re_open, transitions_to: :docs_ordered
    end
    state :canceled
  end

  attr_accessor :job_complete

  validates :lender, presence: true

	def advance_state
    if self.job_complete? && self.can_mark_complete?
      self.mark_complete!
    elsif (reconveyance_filed_changed? && !!reconveyance_filed) && self.can_file_reconveyance?
      self.file_reconveyance!
    elsif (docs_delivered_on_changed? && docs_delivered_on.present?) && self.can_deliver_docs?
			self.deliver_docs!
		end
	end

  def job_complete?
    !!@job_complete
  end
end
