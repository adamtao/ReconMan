require 'rails_helper'

RSpec.describe DashboardController do

  before do
    user = FactoryGirl.create(:user, :processor)
    sign_in(user)
  end

  describe "GET index" do

    before do
      @current_jobs = FactoryGirl.create_list(:tracking_job, 3)

      get :index
    end

    it "assigns @current_jobs" do
      expect(assigns(:current_jobs)).to include(@current_jobs.first)
    end

    it "assigns @products" do
      expect(assigns(:products)).to include(Product.first)
    end

    it "assigns @clients" do
      expect(assigns(:clients)).to include(Client.first)
    end

    it "assigns @counties_needing_work" do
      expect(assigns(:counties_needing_work)).to include(@current_jobs.first.county)
    end

    it "renders dashboard/index template" do
      expect(response).to render_template('index')
    end

  end

end
