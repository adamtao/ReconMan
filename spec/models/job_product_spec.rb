describe JobProduct do

	before(:all) do
		@product = FactoryGirl.create(:product, performs_search: true)
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

  describe "product requiring search" do 
	  describe "workflow state: new" do

	  	describe "county has online search" do

	  		before(:all) do 
	  			@job.county = FactoryGirl.create(:county, state: @state, search_url: "http://foo.bar.com")
	  		end

		  	it "should not toggle its status" do 
		  		@job_product.workflow_state = "new"
		  		@job_product.save!
		  		expect(@job_product.current_state).to eq("new")
		  		@job_product.toggle!
		  		expect(@job_product.current_state).to eq("new")
		  	end

		  	it "advances to in_progress when search_url is provided" do 
		  		@job_product.search_url = "http://test.me"
		  		@job_product.save!
		  		expect(@job_product.current_state).to eq("in_progress")
		  	end

		  end

		  describe "county has offline search" do 

		  	before(:all) do 
	  			@job.county = FactoryGirl.create(:county, state: @state, search_url: nil)
	  			@job.save!
	  		end

				it "automatically advances to offline search status" do
					@job_product.save!
					expect(@job_product.current_state).to eq("to_be_searched_manually")
				end
				
			end

		end

		it "should have an estimated reconveyance time" do
      county = @job.county
      county.search_url = 'http://foo.com'
      county.save!
      tracking_product = FactoryGirl.create(:product, job_type: 'tracking', performs_search: true)
      20.times do
        close_on = [60,45,90,100].sample.days.ago
        job = FactoryGirl.create(:job, county: county, job_type: 'tracking', close_on: close_on)
        FactoryGirl.create(:job_product, job: job, product: tracking_product,
                           recorded_on: 11.days.ago, workflow_state: 'complete')
        job.mark_complete!
      end
      county.calculate_days_to_complete!
      @job.close_on = 50.days.ago
      @job.save
      expect(@job_product.due_on).to be_an_instance_of(Date)
      expect(@job_product.expected_completion_on).not_to eq(@job.close_on)
      expect(@job_product.expected_completion_on).to eq(@job.close_on.advance(days: county.average_days_to_complete))
    end

	end

	describe "non-search product" do 

		before(:all) do 
			@other_product = FactoryGirl.create(:product, performs_search: false)
			@other_job_product = FactoryGirl.build(:job_product, job: @job, product: @other_product)
		end

		it "automatically advances to process manually status" do 
			@other_job_product.save!
			expect(@other_job_product.current_state).to eq("to_be_processed_manually")
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

    describe "#mark_defect!" do

    	before(:each) do 
    		@defect_job = FactoryGirl.create(:job, client: @client, state: @state)
    		@defect_job_product = FactoryGirl.create(:job_product, job: @defect_job, product: @product, workflow_state: 'in_progress')
    		@defect_job.job_products << @defect_job_product
    		@defect_job.save!
    	end

      it "should create a defect clearance job when marked 'defect'" do
        b = @defect_job.job_products.length
        @defect_job_product.mark_defect!
        @defect_job.reload
        expect(@defect_job.job_products.length).to eq(b+1)
      end
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



	end

  # it "should perform automated search" # later, when implementing cached search results
  # it "should log search results" # later, when implementing cached search results
  # it "should determine is search changed" # later, when implementing cached search results

end

