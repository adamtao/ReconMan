describe Zipcode do

  before(:each) do 
  	@county = create(:county)
  	@state = @county.state
  	@zipcode = build(:zipcode, state: @state.abbreviation, county: @county.name)
  end

  subject { @zipcode }

  it "should lookup related state" do
  	expect(@zipcode.lookup_state).to eq(@state)
  end

  it "should lookup related county" do
  	expect(@zipcode.lookup_county).to eq(@county)
  end

  it "should import from CSV, deleting all previous records" do
  	@zipcode.zipcode = "11111"
  	@zipcode.save!

  	# test file has exactly 2 entries plus a header 
  	Zipcode.import_from_csv(Rails.root.join('spec', 'fixtures', 'zip_code_database_fixture.csv'))

  	expect(Zipcode.count).to eq(2)
  	expect(Zipcode.pluck(:zipcode)).to include("05060") # one from the test csv file
  	expect(Zipcode.pluck(:zipcode)).not_to include(@zipcode.zipcode)
  end

end
