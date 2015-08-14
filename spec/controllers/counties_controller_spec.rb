require 'rails_helper'

RSpec.describe CountiesController do

  before :all do
    @user = FactoryGirl.create(:user, :processor)
    @state = FactoryGirl.create(:state)
    @county = FactoryGirl.create(:county, state: @state)
  end

  before :each do
    sign_in(@user)
  end

  describe "GET index" do
    before do
      get :index, state_id: @state.id
    end

    it "assigns @state and its @counties" do
      expect(assigns(:state)).to eq(@state)
      expect(assigns(:counties)).to include(@county)
    end

    it "renders index template" do
      expect(response).to render_template('index')
    end
  end

  describe "GET show" do

    before do
      get :show, state_id: @state.id, id: @county.id
    end

    it "assigns @county" do
      expect(assigns(:state)).to eq(@state)
      expect(assigns(:county)).to eq(@county)
    end

    it "renders counties/show template" do
      expect(response).to render_template('show')
    end
  end

  describe "GET new" do
    before do
      get :new, state_id: @state.id
    end

    it "builds @county belonging to @state" do
      expect(assigns(:county)).to be_a_new(County)
      expect(assigns(:county).state).to eq(@state)
    end

    it "renders the new form" do
      expect(response).to render_template('new')
    end
  end

  describe "GET edit" do
    before do
      get :edit, state_id: @state.id, id: @county.id
    end

    it "assigns @state and @county" do
      expect(assigns(:state)).to eq(@state)
      expect(assigns(:county)).to eq(@county)
    end

    it "renders the edit form" do
      expect(response).to render_template('edit')
    end
  end

  describe "PUT checkout" do

    before do
      @job = FactoryGirl.create(:tracking_job, county: @county)

      put :checkout, id: @county.id
    end

    it "redirects to @job" do
      expect(response).to redirect_to(job_path(@job))
    end

    it "checksout @county to current_user" do
      @county.reload
      expect(@county.checked_out?).to be(true)
      expect(@county.checked_out_to).to eq(@user)
    end
  end

  describe "PUT checkin" do

    before do
      user = FactoryGirl.create(:user, :processor)
      @county.update_column(:checked_out_to_id, user.id)
      @county.update_column(:checked_out_at, 2.minutes.ago)

      put :checkin, id: @county.id
    end

    it "redirects to root path" do
      expect(response).to redirect_to(root_path)
    end

    it "checks in the county" do
      @county.reload

      expect(@county.checked_out?).to be(false)
    end
  end

  describe "POST create successfully" do
    before do
      @county_params = FactoryGirl.attributes_for(:county)

      post :create, state_id: @state.id, county: @county_params
    end

    it "creates the new county" do
      expect(assigns(:county).valid?).to be(true)
      expect(assigns(:county).state).to eq(@state)
    end

    it "redirects to the county page" do
      expect(response).to redirect_to(state_county_path(@state, assigns(:county)))
    end
  end

  describe "POST create invalid data" do
    before do
      post :create, state_id: @state.id, county: {name: ""}
    end

    it "renders the new form" do
      expect(response).to render_template("new")
    end
  end

  describe "PUT update successfully" do
    before do
      @new_county_params = FactoryGirl.attributes_for(:county)

      put :update, state_id: @state.id, id: @county.id, county: @new_county_params
    end

    it "updates the county" do
      @county.reload
      expect(@county.name).to eq(@new_county_params[:name])
    end

    it "redirects to the county page" do
      expect(response).to redirect_to(state_county_path(@state, @county))
    end
  end

  describe "PUT update invalid params" do
    before do
      put :update, state_id: @state.id, id: @county.id, county: { name: '' }
    end

    it "renders the edit form" do
      expect(response).to render_template("edit")
    end

    it "does not update the @county" do
      @county.reload
      expect(@county.name).not_to eq('')
    end
  end

  describe "DELETE destroy successfuly" do
    before do
      delete :destroy, state_id: @state.id, id: @county.id
    end

    it "deletes the county" do
      expect(County.exists?(@county.id)).to be(false)
    end

    it "redirects to the state page" do
      expect(response).to redirect_to(state_path(@state))
    end
  end

  describe "DELETE destroy when county has jobs" do
    before do
      FactoryGirl.create(:job, county: @county)

      delete :destroy, state_id: @state.id, id: @county.id
    end

    it "doesn't delete county with jobs" do
      expect(County.exists?(@county.id)).to be(true)
    end

    it "redirects to county page if it has jobs" do
      expect(response).to redirect_to(state_county_path(@state, @county))
    end
  end
end
