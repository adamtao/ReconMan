require 'rails_helper'

describe Report do

  before do
    @job_products = FactoryGirl.create_list(
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
  it { should respond_to(:exclude_billed) }

  context "with a Client" do

    before do
      @client = @job_products.first.job.client
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
      expect(@report.job_products.first).to be_an_instance_of(JobProduct)
    end

    it ".mark_all_billed! should mark all jobs billed" do
      job_product = @report.job_products.first

      @report.mark_all_billed!
      job_product.reload

      expect(job_product.billed?).to eq(true)
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
        @billed_job_product = FactoryGirl.create(
          :tracking_job_product,
          cleared_on: 1.week.ago,
          workflow_state: 'complete',
          billed: true,
          job_id: @job_products.first.job_id
        )
      end

      it "should exclude billed jobs when exclude_billed = true" do
        @report.exclude_billed = true

        expect(@report.job_products).not_to include(@billed_job_product)
      end

      it "should include billed jobs when exclude_billed = false" do
        @report.exclude_billed = false

        expect(@report.job_products).to include(@billed_job_product)
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
