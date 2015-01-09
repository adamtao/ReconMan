require 'rails_helper'

RSpec.describe Branch do

  before(:each) { @branch = FactoryGirl.create(:branch) }

  subject { @branch }

  it { should respond_to(:client) }

  it "#jobs returns a filtered set of jobs" do
		branch_user = FactoryGirl.create(:user, branch: @branch)
		job = FactoryGirl.create(:job, requestor: branch_user, client: @branch.client)

	  expect(@branch.jobs).to include(job)
  end

  describe "users" do
    before do
      @zachary = FactoryGirl.create(:user, name: "Zachary John Taylor")
      @aaron   = FactoryGirl.create(:user, name: "Aaron The Aardvark")
      @branch.users << @zachary
      @branch.users << @aaron
    end

    it "should have users" do
      expect(@branch.users).to include(@zachary)
    end

    it "should be in alphabetical order" do
      expect(@zachary.id).to be < @aaron.id
      expect(@branch.users.first).to eq(@aaron)
    end
  end
end
