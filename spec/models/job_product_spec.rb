describe JobProduct do

	before(:all) do
		@product = FactoryGirl.create(:product)
		@client = FactoryGirl.create(:client)
		@state = FactoryGirl.create(:state)
		@job = FactoryGirl.create(:job, client: @client, state: @state)
	end

  before(:each) do 
  	@job_product = FactoryGirl.build(:job_product, job: @job, product: @product)
  end

  subject { @job_product }
  it { should respond_to(:name) } # from related job
  it { should respond_to(:county) } # from related job
  it { should respond_to(:quick_search_url) } # from self or related county

  it "should determine the due date" do 
  	@job_product.determine_due_date
  	expect(@job_product.due_on).to eq(Date.today.advance(days: @state.due_within_days))
  end

  it "should set the price" do 
  	@job_product.set_price
  	expect(@job_product.price).to eq(@product.price)
  end

  it "should not be late when new" do 
  	@job_product.determine_due_date
  	expect(@job_product.late?).to be false
  end

  it "should be late way in the future" do 
  	@job_product.due_on = 5.years.ago
  	expect(@job_product.late?).to be true
  end

  it "should toggle its status"
  it "#mark_complete should complete itself"
  it "#mark_complete should complete parent without more open tasks"
  it "#mark_complete should NOT complete parent with more open tasks"
  it "should reopen itself and parent job"

  it "should advance its state" # need complicated setups here

  it "should perform automated search" # later, when implementing cached search results
  it "should log search results" # later, when implementing cached search results
  it "should determine is search changed" # later, when implementing cached search results

end


__END__

	def advance_state
		if search_url_changed? && self.can_search?
			self.search!
		elsif self.job.county.offline_search? && self.can_offline_search?
			self.offline_search!
		elsif !self.product.performs_search? && self.can_process_manually?
			self.process_manually!
		elsif (new_deed_of_trust_number_changed? && new_deed_of_trust_number.present?) && self.can_mark_complete?
			self.recorded_on ||= Date.today
			self.mark_complete!
		end
	end

	# When this product is complete, mark the parent job complete unless
	# it has other incomplete products
	def mark_complete
		unless self.job.job_products.where.not(id: self.id, workflow_state: 'complete').count > 0
			self.job.mark_complete! if self.job.can_mark_complete?
		end
	end

	def re_open
		self.job.re_open! if self.job.can_re_open?
	end

	# Quick way to complete/un-complete, by convention, invokes the last action for the current state
	def toggle!
		if self.can_mark_complete? 
			self.mark_complete! 
		elsif self.can_re_open?
			self.re_open!
		end
	end