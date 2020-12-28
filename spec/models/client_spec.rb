require 'rails_helper'

RSpec.describe Client do

  before(:all) do
    @client = create(:client)
    @branch = create(:branch, client: @client)
    branch_user = create(:user, branch: @branch)
    @oldest_job = create(:job, requestor: branch_user, client: @branch.client)
    create(:task, job: @oldest_job, due_on: 1.year.ago)
    @newest_job = create(:job, requestor: branch_user, client: @branch.client)
    create(:task, job: @newest_job, due_on: 1.day.ago)
  end

  subject { @client }

  it "should lookup a price for product" do
  	client_product = create(:client_product, client: @client)
  	product = client_product.product

  	expect(@client.product_price(product)).to eq(client_product.price)
  end

  describe "current_jobs" do
    it "collects jobs with current tasks" do
      expect(@client.current_jobs).to include(@oldest_job)
      expect(@client.current_jobs).to include(@newest_job)
    end

    it "has them in the right order" do
      expect(@client.current_jobs.first).to eq(@oldest_job)
      expect(@client.current_jobs.last).to eq(@newest_job)
    end
  end

  describe "users" do
    before do
      @zachary = create(:user, name: "Zachary John Taylor")
      @aaron   = create(:user, name: "Aaron The Aardvark")
      @branch.users << @zachary
      @branch2 = create(:branch, client: @client)
      @branch2.users << @aaron
    end

    it "should have users when a branch has users" do
      expect(@client.users).to include(@zachary)
    end

    it "should be in alphabetical order" do
      expect(@zachary.id).to be < @aaron.id
      expect(@client.users.first).to eq(@aaron)
    end
  end

  describe "with contacts" do
	  it "#billing_contact should lookup billing contact" do
			employee = create(:user, branch: @branch, billing_contact: true)

			expect(@client.billing_contact).to eq(employee)
	  end

	  it "#primary_contact should lookup primary contact" do
	  	employee = create(:user, branch: @branch, primary_contact: true)

	  	expect(@client.primary_contact).to eq(employee)
	  end
	end

  describe "with no contacts" do
	  it "#billing_contact should be nil" do
			expect(@client.billing_contact).to eq(nil)
	  end

	  it "#primary_contact should be nil" do
	  	expect(@client.primary_contact).to eq(nil)
	  end
  end

end
