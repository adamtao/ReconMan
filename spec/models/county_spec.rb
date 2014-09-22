describe County do

  before(:each) do 
  	@county = FactoryGirl.build(:county) 
  end

  subject { @county }

  it { should respond_to(:offline_search?) }

end
