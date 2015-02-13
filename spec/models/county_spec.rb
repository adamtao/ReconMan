require 'rails_helper'

describe County do

  context "with offline search" do
    before(:each) do
      @county = FactoryGirl.build_stubbed(:county)
    end

    subject { @county }

    it { should respond_to(:offline_search?) }
  end

  describe "checkout county" do
    before do
      @county = FactoryGirl.create(:county)
      @tracking_tasks = FactoryGirl.create_list(:tracking_task, 5)
      @tracking_tasks.each_with_index do |task,i|
        task.update_column(:due_on, (i+1).weeks.ago)
        task.job.update_column(:county_id, @county.id)
      end
      @tracking_jobs = @tracking_tasks.map{|tjp| tjp.job}
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

    it "first job should be the one with the oldest due date" do
      expect(@county.current_jobs.first).to eq(@tracking_jobs.last)
    end

    it ".next_job loads the second job (if any) ready to process" do
      expect(@county.next_job(@tracking_jobs.last)).to eq(@tracking_jobs[3])
    end

    it ".next_job loads a job after having completed the job" do
      @tracking_jobs.last.update_column(:workflow_state, "complete")

      expect(@county.next_job(@tracking_jobs.last)).to eq(@tracking_jobs[3])
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

  context "deleting" do
    before do
      @job = FactoryGirl.create(:job)
      @county = @job.county
    end

    it "should complain if there are ANY jobs associated" do
      expect{@county.destroy}.to raise_error
    end
  end
end
