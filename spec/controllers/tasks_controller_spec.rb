require 'rails_helper'

RSpec.describe TasksController do

  before :all do
    @job = FactoryGirl.create(:job)
    @product = FactoryGirl.create(:product)
    @task = FactoryGirl.create(:task, product: @product, job: @job)
    @user = FactoryGirl.create(:user, :processor)
  end

  before :each do
    sign_in(@user)
  end

  describe "GET index" do
    before do
      get :index, params: { job_id: @job.id }
    end

    it "assigns @job" do
      expect(assigns(:job)).to eq(@job)
    end

    it "assigns @tasks based on job_id" do
      expect(assigns(:tasks)).to include(@task)
    end

    it "renders jobs/index template" do
      expect(response).to render_template("index")
    end
  end

  describe "GET show" do

    before do
      get :show, params: { job_id: @job.id, id: @task.id }
    end

    it "assigns @job, @task" do
      expect(assigns(:job)).to eq(@job)
      expect(assigns(:task)).to eq(@task)
    end

    it "renders show template" do
      expect(response).to render_template('show')
    end
  end

  describe "GET new" do

    before do
      get :new, params: { job_id: @job.id }
    end

    it "assigns @job, @task, @task.worker" do
      expect(assigns(:job)).to eq(@job)
      expect(assigns(:task)).to be_a_new(Task)
      expect(assigns(:task).worker).to eq(@user)
    end

    it "renders new template" do
      expect(response).to render_template("new")
    end

  end

  describe "POST create" do

    before do
      task_params = FactoryGirl.attributes_for(:task)

      task_params[:worker_id] = @user.id
      task_params[:product_id] = @product.id
      task_params[:payoff_amount] = task_params.delete(:payoff_amount_cents) / 100
      task_params[:price] = task_params.delete(:price_cents) / 100
      task_params[:deed_of_trust_number] = "12345"
      task_params[:beneficiary_account] = "5678"
      post :create, params: { job_id: @job.id, task: task_params.except(:due_on) }
    end

    it "builds @task" do
      task = assigns(:task)

      expect(task.new_record?).to be(false)
      expect(task).to be_an_instance_of(Task)
      expect(task.deed_of_trust_number).to eq("12345")
      expect(task.beneficiary_account).to eq("5678")
      expect(task.job).to eq(@job)
      expect(task.creator).to eq(@user)
    end

    it "redirects to show action" do
      expect(response).to redirect_to(job_path(@job))
    end
  end

  describe "POST create (with errors)" do
    before do
      post :create, params: { job_id: @job.id, task: {phone: "1234"} }
    end

    it "renders the new template" do
      expect(response).to render_template("new")
    end
  end

  describe "GET edit" do

    before do
      get :edit, params: { job_id: @job.id, id: @task.id }
    end

    it "assigns @job, @task" do
      expect(assigns(:job)).to eq(@job)
      expect(assigns(:task)).to eq(@task)
    end

    it "renders edit template" do
      expect(response).to render_template("edit")
    end
  end

  describe "PUT update" do

    before do
      @new_task_params = FactoryGirl.attributes_for(:task)

      put :update, params: { job_id: @job.id, id: @task.id, task: @new_task_params.except(:payoff_amount_cents, :due_on, :price_cents) }
    end

    it "updates @task" do
      expect(assigns(:task).deed_of_trust_number).to eq(@new_task_params[:deed_of_trust_number])
    end

    it "redirects to show action" do
      expect(response).to redirect_to(job_path(@job))
    end
  end

  describe "PUT update (with errors)" do

    before do
      put :update, params: { job_id: @job.id, id: @task.id, task: {product_id: ""} }
    end

    it "should render the edit form" do
      expect(response).to render_template("edit")
    end
  end

  describe "DELETE destroy" do

    before do
      delete :destroy, params: { job_id: @job.id, id: @task.id }
    end

    it "should delete the task" do
      expect(Task.exists?(@task.id)).to be(false)
    end

    it "should redirect to the job show page" do
      expect(response).to redirect_to(job_path(@job))
    end
  end

  describe "GET research" do

    before do
      @task.update_column(:search_url, "http://county.lvh.me")
      get :research, params: { job_id: @job.id, id: @task.id }
    end

    it "should log a search" do
      @task.reload
      expect(@task.search_logs.length).to eq(1)
    end

    it "should redirect to the stored search url" do
      expect(response).to redirect_to(@task.search_url)
    end
  end

  describe "POST toggle_billing" do

    it "should mark the task billed" do
      @task.update_column(:billed, false)

      post :toggle_billing, params: { id: @task.id, format: :js }

      @task.reload
      expect(@task.billed?).to be(true)
    end

    it "should mark the task NOT billed" do
      @task.update_column(:billed, true)

      post :toggle_billing, params: { id: @task.id, format: :js }

      @task.reload
      expect(@task.billed?).to be(false)
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH first_notice_sent" do

    before do
      patch :first_notice_sent, params: { job_id: @job.id, id: @task.id }
    end

    it "should set the status of the task to 'first_notice'" do
      @task.reload
      expect(@task.workflow_state).to eq("first_notice")
    end

    it "should set the first_notice_sent_on date" do
      @task.reload
      expect(@task.first_notice_sent_on).to eq(Date.today)
    end

    it "should redirect to the task path" do
      expect(response).to redirect_to(job_url(@task.job))
    end

  end

  describe "PATCH second_notice_sent" do

    before do
      @task.update_column(:workflow_state, 'first_notice')
      patch :second_notice_sent, params: { job_id: @job.id, id: @task.id }
    end

    it "should set the status of the task to 'second_notice'" do
      @task.reload
      expect(@task.workflow_state).to eq("second_notice")
    end

    it "should set the second_notice_sent_on date" do
      @task.reload
      expect(@task.second_notice_sent_on).to eq(Date.today)
    end

    it "should redirect to the task path" do
      expect(response).to redirect_to(job_url(@task.job))
    end

  end

end
