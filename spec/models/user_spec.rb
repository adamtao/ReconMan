require 'rails_helper'

describe User do

  before(:all) { @user = User.new(email: 'user@example.com') }

  subject { @user }

  it { should respond_to(:email) }

  it "#email returns a string" do
    expect(@user.email).to match 'user@example.com'
  end

  context "processors" do
    before do
      @processor = create(:user, :processor)
    end

    it "#checkout_county should checkout the county to a user" do
      county = create(:county)
      @processor.checkout_county(county)

      expect(@processor.checked_out_county).to eq(county)
    end

    it "#check_in_county should check in the county" do
      county = create(:county)
      @processor.checkout_county(county)

      @processor.check_in_county

      county.reload
      expect(county.checked_out?).to be(false)
      expect(@processor.checked_out_county).to be(false)
    end
  end
end
