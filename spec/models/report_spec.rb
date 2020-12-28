require 'rails_helper'

describe Report do

  before do
    @tasks = create_list(
      :tracking_task, 2,
      cleared_on: 1.week.ago,
      workflow_state: 'complete',
      price_cents: 1999
    )
    @report = Report.new(start_on: 1.month.ago, end_on: 1.day.ago)
  end

  subject { @report }
  it { should respond_to(:client_id) }
  it { should respond_to(:start_on) }
  it { should respond_to(:end_on) }
  it { should respond_to(:lender_id) }
  it { should respond_to(:show_pricing) }
  it { should respond_to(:job_status) }
  it { should respond_to(:to_xls) }
  it { should respond_to(:exclude_billed) }

  context "with a Client" do

    before do
      @client = @tasks.first.job.client
      @report.client_id = @client.id
      @report.job_status = 'Complete'
    end

    it ".title should generate a title" do
      expect(@report.title).to match(/Jobs.*#{@client.name}/)
    end

    it ".subtitle should have the date range" do
      expect(@report.subtitle).to match(/from/i)
    end

    it ".tasks should return a collection" do
      expect(@report.tasks.first).to be_an_instance_of(TrackingTask)
    end

    it ".mark_all_billed! should mark all jobs billed" do
      task = @report.tasks.first

      @report.mark_all_billed!
      task.reload

      expect(task.billed?).to eq(true)
    end

    context "and pricing" do
      before do
        @report.show_pricing = true
      end

      it ".total should have the total" do
        expect(@report.total).to be_an_instance_of(Money)
        #expect(@report.total.to_f).to be > 0.0
      end
    end

    context "complete jobs" do
      it ".headers should not have notices" do
        expect(@report.headers).not_to include("1st Notice")
      end
    end

    context "in-progress jobs" do
      it ".headers should have notices" do
        @report.job_status = "In Progress"
        expect(@report.headers).to include("1st Notice")
      end
    end

    context "billed jobs" do
      before do
        @billed_task = create(
          :tracking_task,
          cleared_on: 1.week.ago,
          workflow_state: 'complete',
          billed: true,
          job_id: @tasks.first.job_id
        )
      end

      it "should exclude billed jobs when exclude_billed = true" do
        @report.exclude_billed = true

        expect(@report.tasks).not_to include(@billed_task)
      end

      it "should include billed jobs when exclude_billed = false" do
        @report.exclude_billed = false

        expect(@report.tasks).to include(@billed_task)
      end
    end
  end

  context "without a Client" do

    before do
      @report = Report.new(start_on: 1.month.ago, end_on: 1.day.ago)
    end

    it ".client should be false" do
      expect(@report.client).to be(false)
    end

    it ".title should generate a title" do
      expect(@report.title).to match(/Jobs/)
    end

    it ".tasks should return a collection" do
      expect(@report.tasks.first).to be_an_instance_of(TrackingTask)
    end
  end

  context "In Progress jobs" do

    before do
      @report = Report.new(job_status: "In Progress")
    end

    it "should include jobs to be searched manually" do
      tracking_job = create(:tracking_task, workflow_state: "to_be_processed_manually")

      expect(@report.tasks).to include(tracking_job)
    end

    it "should include jobs that need review" do
      tracking_job = create(:tracking_task, workflow_state: "needs_review")

      expect(@report.tasks).to include(tracking_job)
    end

    it "should include jobs to be searched manually" do
      tracking_job = create(:tracking_task, workflow_state: "to_be_searched_manually")

      expect(@report.tasks).to include(tracking_job)
    end

    it "should NOT include completed jobs" do
      tracking_job = create(:tracking_task, workflow_state: "complete")

      expect(@report.tasks).not_to include(tracking_job)
    end

    it "should NOT include new jobs" do
      tracking_job = create(:tracking_task)
      tracking_job.update_column(:workflow_state, 'new')

      expect(@report.tasks).not_to include(tracking_job)
    end

    it "should NOT include canceled jobs" do
      tracking_job = create(:tracking_task, workflow_state: "canceled")

      expect(@report.tasks).not_to include(tracking_job)
    end
  end
end
