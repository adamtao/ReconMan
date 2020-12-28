require 'rails_helper'

RSpec.describe Branch do

  before(:all) do
    @branch = create(:branch)
    branch_user = create(:user, branch: @branch)
    @oldest_job = create(:job, requestor: branch_user, client: @branch.client)
    create(:task, job: @oldest_job, due_on: 1.year.ago)
    @newest_job = create(:job, requestor: branch_user, client: @branch.client)
    create(:task, job: @newest_job, due_on: 1.day.ago)
  end

  subject { @branch }

  it { should respond_to(:client) }

  it "#jobs returns a filtered set of jobs" do
	  expect(@branch.jobs).to include(@newest_job)
  end

  describe "current_jobs" do
    it "collectsjobs with current tasks" do
      expect(@branch.current_jobs).to include(@oldest_job)
      expect(@branch.current_jobs).to include(@newest_job)
    end

    it "has them in the right order" do
      cj = @branch.current_jobs

      expect(cj.length).to eq(2)
      expect(cj.first).to eq(@oldest_job)
      expect(cj.last).to eq(@newest_job)
    end
  end

  describe "users" do
    before do
      @zachary = create(:user, name: "Zachary John Taylor")
      @aaron   = create(:user, name: "Aaron The Aardvark")
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
