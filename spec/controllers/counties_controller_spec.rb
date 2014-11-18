require 'rails_helper'

RSpec.describe CountiesController do

  before do
    @user = FactoryGirl.create(:user, :processor)
    sign_in(@user)
    @state = FactoryGirl.create(:state)
  end

  describe "GET show" do

    before do
      @county = FactoryGirl.create(:county, state: @state)

      get :show, state_id: @state.id, id: @county.id
    end

    it "assigns @county" do
      expect(assigns(:state)).to eq(@state)
      expect(assigns(:county)).to eq(@county)
    end
  end

  describe "PUT checkout" do

    before do
      @county = FactoryGirl.create(:county)
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
      @county = FactoryGirl.create(:county,
        checked_out_to_id: user.id, checked_out_at: 2.minutes.ago)

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

end
