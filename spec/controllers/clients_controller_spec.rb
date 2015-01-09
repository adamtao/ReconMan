require 'rails_helper'

RSpec.describe ClientsController do

  before do
    @user = FactoryGirl.create(:user, :processor)
    sign_in(@user)
    @client = FactoryGirl.create(:client)
  end

  describe "GET index" do
    before do
      get :index
    end

    it "assigns @clients" do
      expect(assigns(:clients)).to include(@client)
    end

    it "renders index template" do
      expect(response).to render_template('index')
    end
  end

  describe "GET show" do

    before do
      get :show, id: @client.id
    end

    it "assigns @client" do
      expect(assigns(:client)).to eq(@client)
    end

    it "renders clients/show template" do
      expect(response).to render_template('show')
    end
  end

  describe "GET new" do
    before do
      get :new
    end

    it "builds @client" do
      expect(assigns(:client)).to be_a_new(Client)
    end

    it "renders the new form" do
      expect(response).to render_template('new')
    end
  end

  describe "GET edit" do
    before do
      get :edit, id: @client.id
    end

    it "assigns @client" do
      expect(assigns(:client)).to eq(@client)
    end

    it "renders the edit form" do
      expect(response).to render_template('edit')
    end
  end

  describe "POST create successfully" do
    before do
      @client_params = FactoryGirl.attributes_for(:client)

      post :create, client: @client_params
    end

    it "creates the new client" do
      expect(assigns(:client).valid?).to be(true)
    end

    it "redirects to the client page" do
      expect(response).to redirect_to(client_path(assigns(:client)))
    end
  end

  describe "POST create invalid data" do
    before do
      post :create, client: {name: ""}
    end

    it "renders the new form" do
      expect(response).to render_template("new")
    end
  end

  describe "PUT update successfully" do
    before do
      @new_client_params = FactoryGirl.attributes_for(:client)

      put :update, id: @client.id, client: @new_client_params
    end

    it "updates the client" do
      @client.reload
      expect(@client.name).to eq(@new_client_params[:name])
    end

    it "redirects to the client page" do
      expect(response).to redirect_to(client_path(@client))
    end
  end

  describe "PUT update invalid params" do
    before do
      put :update, id: @client.id, client: { name: '' }
    end

    it "renders the edit form" do
      expect(response).to render_template("edit")
    end

    it "does not update the @client" do
      @client.reload
      expect(@client.name).not_to eq('')
    end
  end

  describe "DELETE destroy" do
    before do
      delete :destroy, id: @client.id
    end

    it "deletes the client" do
      expect(Client.exists?(@client.id)).to be(false)
    end

    it "redirects to the client index" do
      expect(response).to redirect_to(clients_path)
    end
  end

end