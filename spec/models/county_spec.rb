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

  describe "checkout county" do
    before do
      @county = FactoryGirl.create(:county)
      @tracking_jobs = FactoryGirl.create_list(:tracking_job, 3, county: @county)
      @processor = FactoryGirl.create(:user, :processor)
    end

    it ".needing_work should include @county" do
      expect(County.needing_work).to include(@county)
    end

    it ".needing_work should not include counties already checked out" do
      @processor.checkout_county(@county)

      expect(County.needing_work).not_to include(@county)
    end

    it ".needing_work should not include counties with no jobs" do
      no_job_county = FactoryGirl.create(:county)

      expect(County.needing_work).not_to include(no_job_county)
    end

    it ".needing_work should clear timeouts before running" do
      @county.checkout_to(@processor)
      @county.update_column(:checked_out_at, 1.day.ago)

      expect(County.needing_work).to include(@county)
      expect(@county.checked_out?).to be(false)
    end

    it "#checkout should checkout the county to a user" do
      @county.checkout_to(@processor)

      expect(@county.checked_out?).to be(true)
      expect(@county.checked_out_to).to eq(@processor)
    end

    it ".renew_checkout should extend checkout time" do
      @county.checkout_to(@processor)
      @county.update_column(:checked_out_at, 2.minutes.ago)
      original_checkout_time = @county.checked_out_at

      @county.renew_checkout
      @county.reload

      expect(@county.checked_out_at).to be > original_checkout_time
    end

    it ".checkout_expired_for?(user) should see if user had it checked out, but is expired" do
      @county.checkout_to(@processor)
      @county.update_column(:checked_out_at, 1.day.ago)

      expect(@county.checkout_expired_for?(@processor)).to be(true)
    end

    it ".expire_checkout! should manually remove checkout" do
      @county.checkout_to(@processor)

      @county.expire_checkout!

      expect(@county.checked_out?).to be(false)
      expect(@processor.checked_out_county).to be(false)
    end

    it ".checked_out? should timeout after inactivity" do
      @county.checkout_to(@processor)
      @county.update_column(:checked_out_at, 1.day.ago)

      expect(@county.checked_out?).to be(false)
    end

    it ".next_job loads the second job (if any) ready to process" do
      @county.checkout_to(@processor)

      expect(@county.next_job(@tracking_jobs.first)).to eq(@tracking_jobs.second)
    end

    it ".next_job loads a job after having completed the job" do
      @county.checkout_to(@processor)
      @tracking_jobs.first.update_column(:workflow_state, "complete")

      expect(@county.next_job(@tracking_jobs.first)).to eq(@tracking_jobs.second)
    end

    it ".checkout_county expires previously checked out county" do
      @county.checkout_to(@processor)
      county2 = FactoryGirl.create(:county)

      county2.checkout_to(@processor)

      @county.reload
      expect(@county.checked_out?).to be(false)
      expect(@processor.checked_out_county).to eq(county2)
    end
  end
end
