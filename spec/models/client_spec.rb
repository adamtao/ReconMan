describe Client do

  before(:each) { @client = FactoryGirl.build(:client) }

  subject { @client }

  it "should lookup a price for product" do 
  	client_product = FactoryGirl.build(:client_product, client: @client)
  	product = client_product.product
  	expect(@client.product_price(product)).to eq(client_product.price)
  end

  it "should lookup billing contact"
  it "should lookup primary contact"

end
