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

  describe "with a Client" do

    before do
      @client = Client.first
      @report = Report.new(start_on: 1.month.ago, end_on: 1.day.ago, client_id: @client.id)
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

    describe "and pricing" do
      before do
        @report.show_pricing = true
      end

      it ".total should have the total" do
        expect(@report.total).to be_an_instance_of(Money)
        #expect(@report.total.to_f).to be > 0.0
      end
    end
  end

  describe "without a Client" do

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

end
