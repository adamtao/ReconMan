require 'rails_helper'

describe Report do

  before do
    FactoryGirl.create_list(:tracking_job, 2)
  end

  describe "with a Client" do

    before do
      @client = Client.first
      @report = Report.new(start_on: 1.month.ago, end_on: 1.day.ago, client_id: @client.id)
    end

    it ".title should generate a title" do
      expect(@report.title).to match(/Jobs.*#{@client.name}/)
    end

    it ".job_products should return a collection" do
      expect(@report.job_products).to be_an_instance_of(Array)
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
