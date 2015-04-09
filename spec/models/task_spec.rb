require 'rails_helper'

describe Task do

	before(:all) do
    @product = FactoryGirl.create(:tracking_product)
    @client = FactoryGirl.create(:client)
    @state = FactoryGirl.create(:state)
    @job = FactoryGirl.create(:job, client: @client, state: @state)
	end

  before(:each) do
    @task = FactoryGirl.build(:task, job: @job, product: @product)
  end

  subject { @task }
  it { should respond_to(:name) } # from related job
  it { should respond_to(:county) } # from related job
  it { should respond_to(:quick_search_url) } # from self or related county
  it { should respond_to(:first_notice_sent_on) }
  it { should respond_to(:second_notice_sent_on) }

  it "should determine the due date" do
  	@task.determine_due_date

  	expect(@task.due_on).to eq(Date.today.advance(days: @state.due_within_days))
  end

  it "should set the price" do
  	@task.set_price

  	expect(@task.price).to eq(@product.price)
  end

  it "should not be late when new" do
  	@task.determine_due_date

  	expect(@task.late?).to be false
  end

  it "should be late way in the future" do
  	@task.due_on = 5.years.ago

  	expect(@task.late?).to be true
  end

  context "class selectors" do

    it ".complete_between should return tasks collection" do
      @task.save!
      @task.mark_complete!

      tasks = Task.complete_between(2.days.ago, 2.days.from_now)
      expect(tasks).to include(@task)
    end

  end

  context "product requiring search" do
	  context "workflow state: new" do

	  	context "county has online search" do

	  		before(:all) do
	  			@job.county = create(:county, state: @state, search_url: "http://foo.bar.com")
	  		end

		  	it "advances to in_progress when search_url is provided" do
		  		@task.search_url = "http://test.me"
		  		@task.save!

		  		expect(@task.current_state).to eq("in_progress")
		  	end

		  end

		end

		it "should have an estimated reconveyance time" do
      @task.save
      lender = FactoryGirl.create(:lender)
      @task.update_column(:lender_id, lender.id)
      tracking_product = FactoryGirl.create(:tracking_product)
      20.times do
        close_on = [60,45,90,100].sample.days.ago
        job = FactoryGirl.create(:job, job_type: 'tracking', close_on: close_on)
        FactoryGirl.create(:task,
                           job: job,
                           lender: lender,
                           product: tracking_product,
                           recorded_on: 11.days.ago,
                           workflow_state: 'complete')
        job.mark_complete!
      end
      lender.calculate_days_to_complete!

      @job.close_on = 50.days.ago
      @job.save

      expect(@task.due_on).to be_an_instance_of(Date)
      expect(@task.expected_completion_on).not_to eq(@job.close_on)
      expect(@task.expected_completion_on).to eq(@job.close_on.advance(days: lender.average_days_to_complete))
    end

	end

  context "workflow state: in progress" do

  	before(:each) do
  		@task.workflow_state = 'in_progress'
  		@task.save!
  	end

	  it "should toggle its status" do
	  	@task.toggle!

	  	expect(@task.current_state).to eq("complete")

	  	@task.toggle!

	  	expect(@task.current_state).to eq("in_progress")
	  end

	  context "#mark_complete!" do

	  	before(:each) do
	  		@job = @task.job
	  		@job.workflow_state = 'new'
	  		@job.save!
	  	end

      it "should record the cleared_on date" do
        @task.mark_complete!

        @task.reload

        expect(@task.cleared_on).to eq(Date.today)
      end

		  it "should complete itself" do
		  	@task.mark_complete!

		  	expect(@task.current_state).to eq("complete")
		  end

		  it "should complete parent without more open tasks" do
		  	@task.mark_complete!

		  	expect(@task.job.current_state).to eq("complete")
		  end

		  it "should NOT complete parent with more open tasks" do
		  	job = @task.job
		  	create(:task, job: job)

		  	@task.mark_complete!

		  	expect(job.current_state).not_to eq("complete")
		  end
		end

	  it "#re_open! should reopen itself and parent job" do
  		@task.workflow_state = 'in_progress'
  		@task.save!
  		job = @task.job
  		job.workflow_state = 'new'
  		job.save!

  		@task.mark_complete!
  		@task.re_open!

  		expect(@task.current_state).to eq('in_progress')
  		expect(job.current_state).to eq('new')
	  end

	end

  context "calculated workflow dates" do

    before do
      @task.job.state.update_column(:time_to_dispute_days, 30)
      @task.job.state.update_column(:time_to_record_days, 30)
    end

    it ".base_date should be the close date if present" do
      close_date = 2.months.ago.to_date
      @task.job.close_on = close_date
      @task.job.save

      expect(@task.send(:base_date)).to eq(close_date)
    end

    it ".base_date should be the job's creation date if close_on is not present" do
      close_date = 2.months.ago.to_date
      @task.job.close_on = nil
      @task.job.created_at = close_date
      @task.job.save

      expect(@task.send(:base_date)).to eq(close_date)
    end

    # (rule is 5 days + state's time to dispute)
    it ".first_notice_date should be a date 35 days after close" do
      expected_date = @task.send(:base_date).advance(days: 35).to_date

      expect(@task.first_notice_date).to eq(expected_date)
    end

    # (rule is 15 days + time to dispute + time to record)
    it ".second_notice_date should be a date 15+dispute+record after close" do
      expected_date = @task.send(:base_date).advance(days: 75).to_date

      expect(@task.second_notice_date).to eq(expected_date)
    end
  end

  context "generated search URL" do

    before do
      @county = FactoryGirl.create(:county,
                                   state: @state,
                                   search_template_url: 'http://foo.bar/search{{params}}#tab=2',
                                   search_params: 'searchstring={{deed_of_trust_number}}',
                                   search_method: 'GET')
      @job.update_column(:county_id, @county.id)
      @task.deed_of_trust_number = "11223344"
      @task.save
    end

    it "generates a search_url" do
      expect(@task.search_url).to eq('http://foo.bar/search?searchstring=11223344#tab=2')
    end

    it "retains the template in the county" do
      expect(@job.county.search_template_url).to eq(@county.search_template_url)
    end

    it "generates different urls for a multi-item job" do
      task2 = FactoryGirl.create(:tracking_task, job: @job, deed_of_trust_number: "9999")

      expect(task2.search_url).not_to eq(@task.search_url)
      expect(task2.search_url).to eq('http://foo.bar/search?searchstring=9999#tab=2')
    end

    it "wont generate the url if any of the need params are blank" do
      task2 = FactoryGirl.create(:tracking_task, job: @job, deed_of_trust_number: "")

      expect(task2.search_url).to eq(nil)
    end

    describe "#generate_search_params" do
      it "generates search params successfully" do
        params = @task.send(:generate_search_params)

        expect(params).to eq('searchstring=11223344')
      end

      it "generates unique search params for a multi-item job" do
        task2 = FactoryGirl.create(:tracking_task, job: @job, deed_of_trust_number: "9999")
        params = task2.send(:generate_search_params)

        expect(params).not_to eq(@task.send(:generate_search_params))
        expect(params).to eq('searchstring=9999')
      end
    end

    describe "#validate_fields_for_url_generation" do
      it "raises an exception when missing data" do
        task2 = FactoryGirl.build(:tracking_task, job: @job, deed_of_trust_number: "")

        expect { task2.send(:validate_fields_for_url_generation) }.to raise_error("required fields are empty")
      end
    end

  end

  describe "#send_first_notice!" do

    it "updates the first_notice_sent_on field" do
      @task.save
      @task.send_first_notice!
      @task.reload

      expect(@task.first_notice_sent_on).to eq(Date.today)
    end

  end

  describe "#send_second_notice!" do

    it "updates the second_notice_sent_on field" do
      @task.save
      @task.send_first_notice!
      @task.send_second_notice!
      @task.reload

      expect(@task.second_notice_sent_on).to eq(Date.today)
    end

  end

  # it "should perform automated search" # later, when implementing cached search results
  # it "should log search results" # later, when implementing cached search results
  # it "should determine is search changed" # later, when implementing cached search results

end

