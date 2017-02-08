require 'rails_helper'

RSpec.describe DocumentsController do

  before :all do
    @task = FactoryGirl.create(:tracking_task)
    @user = FactoryGirl.create(:user, :processor)
  end

  before :each do
    sign_in(@user)
  end

  describe "POST create" do
    it "creates a new document" do
      file_data = Rack::Test::UploadedFile.new(Rails.root.join("spec", "fixtures", "test_file.doc"), "text/plain")
      post :create, params: { task_id: @task.id, job_id: @task.job_id, document: {file: file_data} }

      expect(@task.documents.length).to eq(1)
      expect(response).to redirect_to(job_path(@task.job))
    end
  end

  describe "DELETE destroy" do
    before do
      @document = FactoryGirl.create(:document, task: @task)

      delete :destroy, params: { id: @document.id, task_id: @task.id, job_id: @task.job_id }
    end

    it "deletes the document" do
      expect(Document.exists?(@document.id)).to be(false)
    end

    it "redirects to the job page" do
      expect(response).to redirect_to(job_path(@task.job))
    end
  end

end
