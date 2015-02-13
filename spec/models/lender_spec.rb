require 'rails_helper'

RSpec.describe Lender, :type => :model do

  before do
    @lender = FactoryGirl.create(:lender)
  end

  subject{@lender}

  it { should respond_to(:tasks) }

  describe ".merge_with!" do

    before do
      @lender2 = FactoryGirl.create(:lender)
      @tracking_task = FactoryGirl.create(:tracking_task, lender: @lender2)

      @lender.merge_with!(@lender2)
    end

    it "should assign jobs from the provided lender to the instance lender" do
      @tracking_task.reload
      expect(@tracking_task.lender).to eq(@lender)
    end

    it "should remove the provided lender after merging" do
      expect(Lender.exists?(@lender2.id)).to be(false)
    end
  end

  context "calculating time to complete" do
    before(:all) do
      @new_lender = FactoryGirl.create(:lender)
      @tracking_product = FactoryGirl.create(:tracking_product)
      @total_days = 0
      total_items = 0
      20.times do
        close_on = [60,45,90,100].sample.days.ago
        job = FactoryGirl.create(:job, job_type: 'tracking', close_on: close_on)
        FactoryGirl.create(:task,
                           job: job,
                           lender: @new_lender,
                           product: @tracking_product,
                           recorded_on: 10.days.ago,
                           workflow_state: 'complete')
        job.mark_complete!
        @total_days += 10.days.ago.to_date - close_on.to_date
        total_items += 1
      end
      @calculated_average = (@total_days / total_items).to_i
    end

    it "should estimate reconveyance time" do
      @new_lender.calculate_days_to_complete!

      expect(@new_lender.average_days_to_complete).to eq(@calculated_average)
      expect(@new_lender.average_days_to_complete).to be > 0
    end

    it "should update the cache when a job is recorded" do
      @new_lender.calculate_days_to_complete!
      b = @new_lender.average_days_to_complete
      new_job = FactoryGirl.create(:job, job_type: 'tracking', close_on: 120.days.ago)
      task = FactoryGirl.create(:task,
         job: new_job,
         lender: @new_lender,
         product: @tracking_product,
         recorded_on: 2.days.ago,
         workflow_state: 'in_progress')
      task.mark_complete!
      @new_lender.reload

      expect(@new_lender.average_days_to_complete).not_to eq(b)
    end

    it "should include more than just the dashboard product in the calculation" do
      job = Job.last
      recorded_on = job.close_on.advance(days: 50)
      FactoryGirl.create(:task,
         job: job,
         lender: @new_lender,
         product: @tracking_product,
         recorded_on: recorded_on,
         workflow_state: 'complete')
      new_calculated_average = ((@total_days + 50 ) / 21).to_i

      @new_lender.calculate_days_to_complete!
      @new_lender.reload

      expect(@new_lender.average_days_to_complete).to eq(new_calculated_average)
    end

  end

  context "calculating time to complete with bad existing records" do
    before(:all) do
      @tracking_product = create(:tracking_product)
      20.times do
        job = create(:job, job_type: 'tracking', close_on: nil)
        FactoryGirl.create(:task,
                           job: job,
                           product: @tracking_product,
                           lender: @lender,
                           recorded_on: 10.days.ago,
                           workflow_state: 'complete')
        job.mark_complete!
      end
    end

    it "should skip estimating reconveyance time" do
      @lender.calculate_days_to_complete!

      expect(@lender.average_days_to_complete).to eq(nil)
    end

  end
end
