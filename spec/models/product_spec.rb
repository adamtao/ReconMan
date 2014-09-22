describe Product do

  before(:each) do 
  	@product = FactoryGirl.build(:product) 
  end

  subject { @product }

  it { should respond_to(:price) }

end
