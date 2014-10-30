require 'rails_helper'

describe Client do

  before(:each) do
  	@client = build_stubbed(:client)
  	@branch = create(:branch, client: @client)
  end

  subject { @client }

  it "should lookup a price for product" do
  	client_product = build(:client_product, client: @client)
  	product = client_product.product

  	expect(@client.product_price(product)).to eq(client_product.price)
  end

  describe "with contacts" do
	  it "#billing_contact should lookup billing contact" do
			employee = create(:user, branch: @branch, billing_contact: true)

			expect(@client.billing_contact).to eq(employee)
	  end

	  it "#primary_contact should lookup primary contact" do
	  	employee = create(:user, branch: @branch, primary_contact: true)

	  	expect(@client.primary_contact).to eq(employee)
	  end
	end

  describe "with no contacts" do
	  it "#billing_contact should be nil" do
			expect(@client.billing_contact).to eq(nil)
	  end

	  it "#primary_contact should be nil" do
	  	expect(@client.primary_contact).to eq(nil)
	  end
  end

end
