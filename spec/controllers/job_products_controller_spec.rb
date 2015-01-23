require 'rails_helper'

RSpec.describe JobProductsController do

  before do
    @job = FactoryGirl.create(:job)
    @product = FactoryGirl.create(:product)
    @job_product = FactoryGirl.create(:job_product, product: @product, job: @job)
    @user = FactoryGirl.create(:user, :processor)
    sign_in(@user)
  end

  describe "GET index" do
    before do
      get :index, job_id: @job.id
    end

    it "assigns @job" do
      expect(assigns(:job)).to eq(@job)
    end

    it "assigns @job_products based on job_id" do
      expect(assigns(:job_products)).to include(@job_product)
    end

    it "renders jobs/index template" do
      expect(response).to render_template("index")
    end
  end

  describe "GET show" do

    before do
      get :show, job_id: @job.id, id: @job_product.id
    end

    it "assigns @job, @job_product" do
      expect(assigns(:job)).to eq(@job)
      expect(assigns(:job_product)).to eq(@job_product)
    end

    it "renders show template" do
      expect(response).to render_template('show')
    end
  end

  describe "GET new" do

    before do
      get :new, job_id: @job.id
    end

    it "assigns @job, @job_product" do
      expect(assigns(:job)).to eq(@job)
      expect(assigns(:job_product)).to be_a_new(JobProduct)
    end

    it "renders new template" do
      expect(response).to render_template("new")
    end

  end

  describe "POST create" do

    before do
      job_product_params = FactoryGirl.attributes_for(:job_product)

      job_product_params[:worker_id] = @user.id
      job_product_params[:product_id] = @product.id
      job_product_params[:payoff_amount] = job_product_params.delete(:payoff_amount_cents) / 100
      job_product_params[:price] = job_product_params.delete(:price_cents) / 100
      post :create, job_id: @job.id, job_product: job_product_params.except(:due_on)
    end

    it "builds @job_product" do
      expect(assigns(:job_product)).to be_an_instance_of(JobProduct)
      expect(assigns(:job_product).job).to eq(@job)
      expect(assigns(:job_product).creator).to eq(@user)
    end

    it "redirects to show action" do
      expect(response).to redirect_to(job_path(@job))
    end
  end

  describe "POST create (with errors)" do
    before do
      post :create, job_id: @job.id, job_product: {phone: "1234"}
    end

    it "renders the new template" do
      expect(response).to render_template("new")
    end
  end

  describe "GET edit" do

    before do
      get :edit, job_id: @job.id, id: @job_product.id
    end

    it "assigns @job, @job_product" do
      expect(assigns(:job)).to eq(@job)
      expect(assigns(:job_product)).to eq(@job_product)
    end

    it "renders edit template" do
      expect(response).to render_template("edit")
    end
  end

  describe "PUT update" do

    before do
      @new_job_product_params = FactoryGirl.attributes_for(:job_product)

      put :update, job_id: @job.id, id: @job_product.id, job_product: @new_job_product_params.except(:payoff_amount_cents, :due_on, :price_cents)
    end

    it "updates @job_product" do
      expect(assigns(:job_product).deed_of_trust_number).to eq(@new_job_product_params[:deed_of_trust_number])
    end

    it "redirects to show action" do
      expect(response).to redirect_to(job_path(@job))
    end
  end

  describe "PUT update (with errors)" do

    before do
      put :update, job_id: @job.id, id: @job_product.id, job_product: {product_id: ""}
    end

    it "should render the edit form" do
      expect(response).to render_template("edit")
    end
  end

  describe "DELETE destroy" do

    before do
      delete :destroy, job_id: @job.id, id: @job_product.id
    end

    it "should delete the job_product" do
      expect(JobProduct.exists?(@job_product.id)).to be(false)
    end

    it "should redirect to the job show page" do
      expect(response).to redirect_to(job_path(@job))
    end
  end

  describe "GET research" do

    before do
      @job_product.update_column(:search_url, "http://county.lvh.me")
      get :research, job_id: @job.id, id: @job_product.id
    end

    it "should log a search" do
      @job_product.reload
      expect(@job_product.search_logs.length).to eq(1)
    end

    it "should redirect to the stored search url" do
      expect(response).to redirect_to(@job_product.search_url)
    end
  end

  describe "POST toggle_billing" do

    it "should mark the job_product billed" do
      @job_product.update_column(:billed, false)

      post :toggle_billing, id: @job_product.id, format: :js

      @job_product.reload
      expect(@job_product.billed?).to be(true)
    end

    it "should mark the job_product NOT billed" do
      @job_product.update_column(:billed, true)

      post :toggle_billing, id: @job_product.id, format: :js

      @job_product.reload
      expect(@job_product.billed?).to be(false)
      expect(response).to be_success
    end
  end

end
