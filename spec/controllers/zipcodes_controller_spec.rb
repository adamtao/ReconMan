require 'rails_helper'

RSpec.describe ZipcodesController do

  before :all do
    @user = FactoryGirl.create(:user, :processor)
  end

  before :each do
    sign_in(@user)
  end

  describe "GET show.json successfully" do

    before do
      @zipcode = FactoryGirl.create(:zipcode, zipcode: "90210")
      get :show, id: @zipcode.zipcode, format: :json
    end

    it "assigns @zipcode" do
      expect(assigns(:zipcode)).to eq(@zipcode)
    end
  end

  describe "GET show.json with dashed zipcode" do

    before do
      @zipcode = FactoryGirl.create(:zipcode, zipcode: "90210-1234")
      get :show, id: @zipcode.zipcode, format: :json
    end

    it "does not match @zipcode" do
      expect(assigns(:zipcode)).to eq(nil)
    end
  end
end
