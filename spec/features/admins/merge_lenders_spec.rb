require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature "Merge lenders", :devise do

  before do
    @me = sign_in_as_admin
    @lender1 = FactoryGirl.create(:lender)
    @lender2 = FactoryGirl.create(:lender)
    @tracking_task = FactoryGirl.create(:tracking_task, lender: @lender2)
  end

  after(:each) do
    Warden.test_reset!
  end

  scenario 'successfully' do
    visit lender_path(@lender1)

    within "form#merge_lender" do
      select @lender2.name, from: "merge_with_id"
      click_on 'Merge'
    end

    @tracking_task.reload
    expect(@tracking_task.lender).to eq(@lender1)
    expect(Lender.exists?(id: @lender2.id)).to be(false)
  end
end
