require 'rails_helper'

describe DocumentationTask do

	before do
    @task = FactoryGirl.create(:documentation_task)
  end

  subject { @task }
  it { should respond_to(:job_complete?) }
  it { should respond_to(:job_complete=) }

  it "should be able to order_docs" do
    expect(@task.can_order_docs?).to be(true)
  end

  it "should update the status to documents ordered" do
    @task.docs_delivered_on = Date.today
    @task.save

    @task.reload
    expect(@task.workflow_state).to eq("docs_delivered")
  end

  it "should update the status to reconveyance filed" do
    @task.docs_delivered_on = Date.today
    @task.reconveyance_filed = true
    @task.save

    @task.reload
    expect(@task.workflow_state).to eq("reconveyance_filed")
  end

  it "should mark the job complete" do
    @task.docs_delivered_on = Date.today
    @task.reconveyance_filed = true
    @task.job_complete = true
    @task.save

    @task.reload
    expect(@task.workflow_state).to eq("complete")
  end


end

