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

  describe "workflow state: new" do

  	it "should not toggle its status" do 
  		@job_product.workflow_state = "new"
  		@job_product.save!
  		@job_product.toggle!
  		expect(@job_product.current_state).to eq("new")
  	end

  end

  describe "workflow state: in progress" do

  	before(:each) do 
  		@job_product.workflow_state = 'in_progress'
  		@job_product.save!
  	end

	  it "should toggle its status" do 
	  	@job_product.toggle!
	  	expect(@job_product.current_state).to eq("complete")
	  	@job_product.toggle!
	  	expect(@job_product.current_state).to eq("in_progress")
	  end

	  describe "#mark_complete!" do

	  	before(:each) do 
	  		@job = @job_product.job
	  		@job.workflow_state = 'new'
	  		@job.save!
	  	end

		  it "should complete itself" do 
		  	@job_product.mark_complete!
		  	expect(@job_product.current_state).to eq("complete")
		  end

		  it "should complete parent without more open tasks" do 
		  	@job_product.mark_complete!
		  	expect(@job_product.job.current_state).to eq("complete")
		  end

		  it "should NOT complete parent with more open tasks" do 
		  	job = @job_product.job
		  	FactoryGirl.create(:job_product, job: job)
		  	@job_product.mark_complete!
		  	expect(job.current_state).not_to eq("complete")
		  end
		end

	  it "#re_open! should reopen itself and parent job" do 
  		@job_product.workflow_state = 'in_progress'
  		@job_product.save!
  		job = @job_product.job
  		job.workflow_state = 'new'
  		job.save!
  		@job_product.mark_complete!
  		@job_product.re_open!
  		expect(@job_product.current_state).to eq('in_progress')
  		expect(job.current_state).to eq('new')
	  end

	  it "should advance its state" # need complicated setups here
	end

  # it "should perform automated search" # later, when implementing cached search results
  # it "should log search results" # later, when implementing cached search results
  # it "should determine is search changed" # later, when implementing cached search results

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

