require 'rails_helper'

RSpec.describe SearchLog, :type => :model do
  it "should advance the job product to in_progress" do
    user = FactoryGirl.create(:user, :processor)
    county = FactoryGirl.create(:county, search_url: "http://foo.com")
    job = FactoryGirl.create(:tracking_job, county: county)
    job_product = FactoryGirl.create(:tracking_job_product, job: job)

    SearchLog.create(
      user: user,
      job_product: job_product,
      status: "Not Cleared"
    )

    expect(job_product.workflow_state).to eq("in_progress")
  end
end

