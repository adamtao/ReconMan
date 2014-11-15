require 'rails_helper'

RSpec.describe JobsController do

  before do
    user = FactoryGirl.create(:user, :processor)
    sign_in(user)
  end

  describe "POST index (search)" do

    before do
      @job1 = FactoryGirl.create(:tracking_job, file_number: "11111")
      @job2 = FactoryGirl.create(:tracking_job, file_number: "12222")
    end

    it "assigns @jobs" do
      post :index, q: { file_number_cont: "1" }

      expect(assigns(:jobs)).to include(@job1)
    end

    it "redirects to view job when single result found" do
      post :index, q: { file_number_cont: "222" }

      expect(response).to redirect_to(job_path(@job2))
    end
  end

  describe "GET index" do

    before do
      @current_job = FactoryGirl.create(:tracking_job)
      @completed_job = FactoryGirl.create(:tracking_job, workflow_state: "complete")

      get :index
    end

    it "assigns @current_jobs" do
      expect(assigns(:current_jobs)).to include(@current_job)
    end

    it "assigns @completed_jobs" do
      expect(assigns(:completed_jobs)).to include(@completed_job)
    end
  end
end
