require 'rails_helper'

describe County do

  context "with offline search" do
    before(:each) do 
      @county = build_stubbed(:county) 
    end

    subject { @county }

    it { should respond_to(:offline_search?) }
  end

	context "calculating time to complete" do
    before(:all) do
      @county = create(:county, search_url: 'http://foo.com')
      @tracking_product = create(:tracking_product)
      @total_days = 0
      total_items = 0
      20.times do 
        close_on = [60,45,90,100].sample.days.ago
        job = create(:job, county: @county, job_type: 'tracking', close_on: close_on)
        create(:job_product, job: job, product: @tracking_product, 
                           recorded_on: 10.days.ago, workflow_state: 'complete')
        job.mark_complete!
        @total_days += 10.days.ago.to_date - close_on.to_date
        total_items += 1
      end
      @calculated_average = (@total_days / total_items).to_i
    end

    it "should estimate reconveyance time" do
      @county.calculate_days_to_complete!

      expect(@county.average_days_to_complete).to eq(@calculated_average) 
      expect(@county.average_days_to_complete).to be > 0
    end

    it "should update the cache when a job is recorded" do
      @county.calculate_days_to_complete!
      b = @county.average_days_to_complete
      new_job = create(:job, county: @county, job_type: 'tracking', close_on: 120.days.ago)
      job_product = create(:job_product, 
         job: new_job, product: @tracking_product, recorded_on: 2.days.ago, workflow_state: 'in_progress')

      job_product.mark_complete!
      @county.reload

      expect(@county.average_days_to_complete).not_to eq(b)
    end

    it "should include more than just the dashboard product in the calculation" do
      job = @county.jobs.last
      recorded_on = job.close_on.advance(days: 50)
      create(:job_product,
         job: job, product: @tracking_product,
         recorded_on: recorded_on, workflow_state: 'complete')
      new_calculated_average = ((@total_days + 50 ) / 21).to_i

      @county.calculate_days_to_complete!
      @county.reload

      expect(@county.average_days_to_complete).to eq(new_calculated_average)
    end

  end

	context "calculating time to complete with bad existing records" do
    before(:all) do
      @county = create(:county, search_url: 'http://foo.com')
      @tracking_product = create(:tracking_product)
      20.times do
        job = create(:job, county: @county, job_type: 'tracking', close_on: nil)
        create(:job_product, job: job, product: @tracking_product,
               recorded_on: 10.days.ago, workflow_state: 'complete')
        job.mark_complete!
      end
    end

    it "should skip estimating reconveyance time" do
      @county.calculate_days_to_complete!

      expect(@county.average_days_to_complete).to eq(nil)
    end

  end
end
