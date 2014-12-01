require 'rails_helper'

RSpec.describe Lender, :type => :model do

  before do
    @lender = FactoryGirl.create(:lender)
  end

  subject{@lender}

  it { should respond_to(:job_products) }

  describe ".merge_with!" do

    before do
      @lender2 = FactoryGirl.create(:lender)
      @tracking_job_product = FactoryGirl.create(:tracking_job_product, lender: @lender2)

      @lender.merge_with!(@lender2)
    end

    it "should assign jobs from the provided lender to the instance lender" do
      @tracking_job_product.reload
      expect(@tracking_job_product.lender).to eq(@lender)
    end

    it "should remove the provided lender after merging" do
      expect(Lender.exists?(@lender2.id)).to be(false)
    end
  end
end
