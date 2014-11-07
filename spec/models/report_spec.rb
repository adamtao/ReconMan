require 'rails_helper'

describe Report do

  before do
    FactoryGirl.create_list(
      :tracking_job_product, 2,
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

  context "with a Client" do

    before do
      @client = Client.first
      @report.client_id = @client.id
      @report.job_status = 'Complete'
    end

    it ".title should generate a title" do
      expect(@report.title).to match(/Jobs.*#{@client.name}/)
    end

    it ".subtitle should have the date range" do
      expect(@report.subtitle).to match(/from/i)
    end

    it ".job_products should return a collection" do
      expect(@report.job_products).to be_an_instance_of(Array)
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

    it ".job_products should return a collection" do
      expect(@report.job_products).to be_an_instance_of(Array)
    end
  end

  context "In Progress jobs" do

    before do
      @report = Report.new(job_status: "In Progress")
    end

    it "should include jobs to be searched manually" do
      tracking_job = FactoryGirl.create(:tracking_job_product, workflow_state: "to_be_processed_manually")

      expect(@report.job_products).to include(tracking_job)
    end

    it "should include jobs that need review" do
      tracking_job = FactoryGirl.create(:tracking_job_product, workflow_state: "needs_review")

      expect(@report.job_products).to include(tracking_job)
    end

    it "should include jobs to be searched manually" do
      tracking_job = FactoryGirl.create(:tracking_job_product, workflow_state: "to_be_searched_manually")

      expect(@report.job_products).to include(tracking_job)
    end

    it "should NOT include completed jobs" do
      tracking_job = FactoryGirl.create(:tracking_job_product, workflow_state: "complete")

      expect(@report.job_products).not_to include(tracking_job)
    end

    it "should NOT include new jobs" do
      tracking_job = FactoryGirl.create(:tracking_job_product)
      tracking_job.update_column(:workflow_state, 'new')

      expect(@report.job_products).not_to include(tracking_job)
    end

    it "should NOT include canceled jobs" do
      tracking_job = FactoryGirl.create(:tracking_job_product, workflow_state: "canceled")

      expect(@report.job_products).not_to include(tracking_job)
    end
  end
end
