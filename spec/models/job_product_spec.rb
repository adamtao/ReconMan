require 'rails_helper'

describe JobProduct do

	before(:all) do
		@product = create(:tracking_product)
		@client = create(:client)
		@state = create(:state)
		@job = create(:job, client: @client, state: @state)
	end

  before(:each) do
  	@job_product = build(:job_product, job: @job, product: @product)
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

  context "tracking job product" do
    before do
      @tracking_job_product = FactoryGirl.create(:tracking_job_product)
    end

    it "should have a related Lender" do
      expect(@tracking_job_product.lender).to be_an_instance_of(Lender)
    end
  end

  context "product requiring search" do
	  context "workflow state: new" do

	  	context "county has online search" do

	  		before(:all) do
	  			@job.county = create(:county, state: @state, search_url: "http://foo.bar.com")
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

		  context "county has offline search" do

		  	before(:all) do
	  			@job.county = create(:county, state: @state, search_url: nil)
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
      tracking_product = create(:product, job_type: 'tracking', performs_search: true)
      20.times do
        close_on = [60,45,90,100].sample.days.ago
        job = create(:job, county: county, job_type: 'tracking', close_on: close_on)
        create(:job_product, job: job, product: tracking_product,
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

	context "non-search product" do

		before(:all) do
			@other_product = create(:product, performs_search: false)
			@other_job_product = build(:job_product, job: @job, product: @other_product)
		end

		it "automatically advances to process manually status" do
			@other_job_product.save!

			expect(@other_job_product.current_state).to eq("to_be_processed_manually")
		end
	end

  context "workflow state: in progress" do

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

	  context "#mark_complete!" do

	  	before(:each) do
	  		@job = @job_product.job
	  		@job.workflow_state = 'new'
	  		@job.save!
	  	end

      it "should record the cleared_on date" do
        @job_product.mark_complete!

        @job_product.reload

        expect(@job_product.cleared_on).to eq(Date.today)
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
		  	create(:job_product, job: job)

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

  context "calculated workflow dates" do

    before do
      @job_product.job.state.update_column(:time_to_dispute_days, 30)
      @job_product.job.state.update_column(:time_to_record_days, 30)
    end

    it ".base_date should be the close date if present" do
      close_date = 2.months.ago.to_date
      @job_product.job.close_on = close_date
      @job_product.job.save

      expect(@job_product.send(:base_date)).to eq(close_date)
    end

    it ".base_date should be the job's creation date if close_on is not present" do
      close_date = 2.months.ago.to_date
      @job_product.job.close_on = nil
      @job_product.job.created_at = close_date
      @job_product.job.save

      expect(@job_product.send(:base_date)).to eq(close_date)
    end

    # (rule is 5 days + state's time to dispute)
    it ".first_notice_date should be a date 35 days after close" do
      expected_date = @job_product.send(:base_date).advance(days: 35).to_date

      expect(@job_product.first_notice_date).to eq(expected_date)
    end

    # (rule is 15 days + time to dispute + time to record)
    it ".second_notice_date should be a date 15+dispute+record after close" do
      expected_date = @job_product.send(:base_date).advance(days: 75).to_date

      expect(@job_product.second_notice_date).to eq(expected_date)
    end
  end
  # it "should perform automated search" # later, when implementing cached search results
  # it "should log search results" # later, when implementing cached search results
  # it "should determine is search changed" # later, when implementing cached search results

end

