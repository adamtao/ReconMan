require 'rails_helper'

describe State do

  before(:all) do
  	@ttnd = 30
  	@ttdd = 45
  	@ttrd = 60
    @state = build(:state,
  		time_to_notify_days: @ttnd,
  		time_to_dispute_days: @ttdd,
  		time_to_record_days: @ttrd
  	)
  end

  subject { @state }

  it { should respond_to(:abbreviation) }
  it { should respond_to(:time_to_dispute_days) }
  it { should respond_to(:time_to_notify_days) }
  it { should respond_to(:time_to_record_days) }

	it "should calculate due_within_days" do
		total_time = @ttnd + @ttdd + @ttrd

		expect(@state.due_within_days).to eq(total_time)
	end

end
