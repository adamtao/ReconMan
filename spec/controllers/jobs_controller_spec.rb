require 'rails_helper'

RSpec.describe JobsController do

  before :all do
    @user = create(:user, :processor)
  end

  before :each do
    sign_in(@user)
  end

  describe "POST index (search)" do

    before do
      @job1 = create(:tracking_job, file_number: "11111")
      @job2 = create(:tracking_job, file_number: "12222")
    end

    it "assigns @jobs" do
      post :index, params: { q: { file_number_cont: "1" } }

      expect(assigns(:jobs)).to include(@job1)
    end

    it "redirects to view job when single result found" do
      post :index, params: { q: { file_number_cont: "222" } }

      expect(response).to redirect_to(job_path(@job2))
    end
  end

  describe "POST create invalid data" do
    before do
      post :create, params: { job: {client_id: ""} }
    end

    it "renders the new form" do
      expect(response).to render_template("new")
    end
  end

  describe "PUT update invalid params" do
    before do
      @job = create(:tracking_job)
      put :update, params: { id: @job.id, job: { client_id: '' } }
    end

    it "renders the edit form" do
      expect(response).to render_template("edit")
    end

    it "does not update the @client" do
      @job.reload
      expect(@job.client_id).not_to eq('')
    end
  end

  describe "GET file_number/FILE.json successfully" do

    before do
      @job = create(:tracking_job)
      get :file_number, params: { id: @job.file_number, format: :json }
    end

    it "assigns @job_id" do
      expect(assigns(:job)).to eq(@job)
    end
  end

  describe "DELETE destroy" do
    before do
      @job = create(:tracking_job)
      delete :destroy, params: { id: @job.id }
    end

    it "deletes the job" do
      expect(Job.exists?(@job.id)).to be(false)
    end

    it "redirects to the client page" do
      expect(response).to redirect_to(client_path(@job.client))
    end
  end
end
