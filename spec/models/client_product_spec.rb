require 'rails_helper'

RSpec.describe ClientProduct do

  before(:each) { @client_product = FactoryGirl.build_stubbed(:client_product) }

  subject { @client_product }

  it { should respond_to(:client) }
  it { should respond_to(:product) }

  it "should load a default price from the related product" do
  	expect(@client_product.price_cents).to eq(@client_product.product.price_cents)
  end

end
