describe Branch do

  before(:each) { @branch = FactoryGirl.build(:branch) }

  subject { @branch }

  it { should respond_to(:client) }

  it "#jobs returns a filtered set of jobs" do
		branch_user = FactoryGirl.create(:user, branch: @branch)
		job = FactoryGirl.create(:job, requestor: branch_user, client: @branch.client)
	  expect(@branch.jobs).to include(job)
  end

end
