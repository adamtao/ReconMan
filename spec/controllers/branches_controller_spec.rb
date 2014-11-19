require 'rails_helper'

RSpec.describe BranchesController do

  before do
    @client = FactoryGirl.create(:client)
    @branch = FactoryGirl.create(:branch, client: @client)
    @user = FactoryGirl.create(:user, :processor)
    sign_in(@user)
  end

  describe "GET index" do
    before do
      get :index, client_id: @client.id
    end

    it "assigns @client" do
      expect(assigns(:client)).to eq(@client)
    end

    it "assigns @branches based on client_id" do
      expect(assigns(:branches)).to include(@branch)
    end

    it "renders clients/index template" do
      expect(response).to render_template("index")
    end
  end

  describe "GET show" do

    before do
      @agent = FactoryGirl.create(:user, branch: @branch)
      @tracking_job = FactoryGirl.create(:tracking_job, client: @client, requestor: @agent)

      get :show, client_id: @client.id, id: @branch.id
    end

    it "assigns @client, @branch" do
      expect(assigns(:client)).to eq(@client)
      expect(assigns(:branch)).to eq(@branch)
    end

    it "assigns jobs collections" do
      expect(assigns(:current_jobs)).to include(@tracking_job)
      expect(assigns(:completed_jobs)).to eq([])
    end

    it "renders branches/show template" do
      expect(response).to render_template('show')
    end
  end

  describe "GET new" do

    before do
      get :new, client_id: @client.id
    end

    it "assigns @client, @branch" do
      expect(assigns(:client)).to eq(@client)
      expect(assigns(:branch)).to be_a_new(Branch)
    end

    it "renders branches/new template" do
      expect(response).to render_template("new")
    end

  end

  describe "POST create" do

    before do
      branch_params = FactoryGirl.attributes_for(:branch)

      post :create, client_id: @client.id, branch: branch_params
    end

    it "builds @branch" do
      expect(assigns(:branch)).to be_an_instance_of(Branch)
      expect(assigns(:branch).client).to eq(@client)
      expect(assigns(:branch).creator).to eq(@user)
    end

    it "redirects to show action" do
      expect(response).to redirect_to(client_branch_path(@client, assigns(:branch)))
    end
  end

  describe "POST create (with errors)" do
    before do
      post :create, client_id: @client.id, branch: {phone: "1234"}
    end

    it "renders the new template" do
      expect(response).to render_template("new")
    end
  end

  describe "GET edit" do

    before do
      get :edit, client_id: @client.id, id: @branch.id
    end

    it "assigns @client, @branch" do
      expect(assigns(:client)).to eq(@client)
      expect(assigns(:branch)).to eq(@branch)
    end

    it "renders edit template" do
      expect(response).to render_template("edit")
    end
  end

  describe "PUT update" do

    before do
      @new_branch_params = FactoryGirl.attributes_for(:branch)

      put :update, client_id: @client.id, id: @branch.id, branch: @new_branch_params
    end

    it "updates @branch" do
      expect(assigns(:branch).name).to eq(@new_branch_params[:name])
    end

    it "redirects to show action" do
      expect(response).to redirect_to(client_branch_path(@client, @branch))
    end
  end

  describe "PUT update (with errors)" do

    before do
      put :update, client_id: @client.id, id: @branch.id, branch: {name: ""}
    end

    it "should render the edit form" do
      expect(response).to render_template("edit")
    end
  end

  describe "DELETE destroy" do

    before do
      delete :destroy, client_id: @client.id, id: @branch.id
    end

    it "should delete the branch" do
      expect(Branch.exists?(@branch.id)).to be(false)
    end

    it "should redirect to the client show page" do
      expect(response).to redirect_to(client_path(@client))
    end
  end

end
