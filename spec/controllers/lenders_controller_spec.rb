require 'rails_helper'

RSpec.describe LendersController do

  before do
    @user = FactoryGirl.create(:user, :processor)
    sign_in(@user)
    @lender = FactoryGirl.create(:lender)
  end

  describe "GET index" do
    before do
      get :index
    end

    it "assigns @lenders" do
      expect(assigns(:lenders)).to include(@lender)
    end

    it "renders index template" do
      expect(response).to render_template('index')
    end
  end

  describe "GET show" do

    before do
      get :show, id: @lender.id
    end

    it "assigns @lender" do
      expect(assigns(:lender)).to eq(@lender)
    end

    it "renders lenders/show template" do
      expect(response).to render_template('show')
    end
  end

  describe "GET new" do
    before do
      get :new
    end

    it "builds @lender" do
      expect(assigns(:lender)).to be_a_new(Lender)
    end

    it "renders the new form" do
      expect(response).to render_template('new')
    end
  end

  describe "GET edit" do
    before do
      get :edit, id: @lender.id
    end

    it "assigns @lender" do
      expect(assigns(:lender)).to eq(@lender)
    end

    it "renders the edit form" do
      expect(response).to render_template('edit')
    end
  end

  describe "POST create successfully" do
    before do
      @lender_params = FactoryGirl.attributes_for(:lender)

      post :create, lender: @lender_params
    end

    it "creates the new lender" do
      expect(assigns(:lender).valid?).to be(true)
    end

    it "redirects to the lender page" do
      expect(response).to redirect_to(lender_path(assigns(:lender)))
    end
  end

  describe "POST create invalid data" do
    before do
      post :create, lender: {name: ""}
    end

    it "renders the new form" do
      expect(response).to render_template("new")
    end
  end

  describe "PUT update successfully" do
    before do
      @new_lender_params = FactoryGirl.attributes_for(:lender)

      put :update, id: @lender.id, lender: @new_lender_params
    end

    it "updates the lender" do
      @lender.reload
      expect(@lender.name).to eq(@new_lender_params[:name])
    end

    it "redirects to the lender page" do
      expect(response).to redirect_to(lender_path(@lender))
    end
  end

  describe "PUT update invalid params" do
    before do
      put :update, id: @lender.id, lender: { name: '' }
    end

    it "renders the edit form" do
      expect(response).to render_template("edit")
    end

    it "does not update the @lender" do
      @lender.reload
      expect(@lender.name).not_to eq('')
    end
  end

  describe "POST merge successfully" do
    before do
      @lender2 = FactoryGirl.create(:lender)
      @tracking_task = FactoryGirl.create(:tracking_task, lender: @lender2)
      post :merge, id: @lender.id, merge_with_id: @lender2.id
    end

    it "merges the lenders" do
      @tracking_task.reload

      expect(@tracking_task.lender).to eq(@lender)
      expect(Lender.exists?(@lender2.id)).to be(false)
    end
  end

  describe "DELETE destroy" do
    before do
      delete :destroy, id: @lender.id
    end

    it "deletes the lender" do
      expect(Lender.exists?(@lender.id)).to be(false)
    end

    it "redirects to the lender index" do
      expect(response).to redirect_to(lenders_path)
    end
  end

end
