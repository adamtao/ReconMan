require 'rails_helper'

describe Product do

  before(:all) do
    @product = build(:product)
  end

  subject { @product }

  it { should respond_to(:price) }

  it ".defect_clearance should return a product" do
  	p = Product.defect_clearance

  	expect(p).to be_an_instance_of(Product)
  	expect(p.name).to eq("Defect Clearance")
  end

end
