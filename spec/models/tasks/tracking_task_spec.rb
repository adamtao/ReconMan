require 'rails_helper'

describe TrackingTask do

	before do
    @task = FactoryGirl.build(:tracking_task)
  end

  it "should have a related Lender" do
    expect(@task.lender).to be_an_instance_of(Lender)
  end

end

