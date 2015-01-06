require 'rails_helper'

describe Zipcode do

  before(:each) do
    @county = FactoryGirl.create(:county)
  	@state = @county.state
    @zipcode = FactoryGirl.build(:zipcode, state: @state.abbreviation, county: @county.name)
  end

  subject { @zipcode }

  it "should import from CSV, deleting all previous records" do
  	@zipcode.zipcode = "11111"
  	@zipcode.save!

  	# test file has exactly 2 entries plus a header
  	Zipcode.import_from_csv(Rails.root.join('spec', 'fixtures', 'zip_code_database_fixture.csv'))

  	expect(Zipcode.count).to eq(2)
  	expect(Zipcode.pluck(:zipcode)).to include("05060") # one from the test csv file
  	expect(Zipcode.pluck(:zipcode)).not_to include(@zipcode.zipcode)
  end

  it "#lookup(zipcode) should find matching zipcode" do
    @zipcode.save
    z = Zipcode.lookup(@zipcode.zipcode)

    expect(z).to eq(@zipcode)
  end

  describe "related state" do
    it "should lookup state" do
      expect(@zipcode.lookup_state).to eq(@state)
    end

    it "should fail gracefully with no state match" do
      @state.update_column(:abbreviation, "ZX")
      @state.reload

      expect(@zipcode.state_id).to eq(nil)
    end
  end

  describe "related county" do
    it "should lookup related county" do
      expect(@zipcode.lookup_county).to eq(@county)
    end

    it "should match related county with different capitalization" do
      @county.update_column(:name, @county.name.upcase)
      @zipcode.county = @county.name.downcase

      @county.reload

      expect(@zipcode.lookup_county).to eq(@county)
    end

    it "should fail gracefully with no county match" do
      @county.update_column(:name, "Not-Matched-Name")
      @county.reload

      expect(@zipcode.county_id).to eq(nil)
    end
  end

end
