require 'rails_helper'

RSpec.describe Comment do

  describe "on jobs" do

	  before(:all) do
      @job = FactoryGirl.create(:job)
      @comment = FactoryGirl.build(:comment, related_type: "Job", related_id: @job.id)
	  end

	  subject { @comment }

	  it "#related should be the @job" do
	  	expect(@comment.related).to eq(@job)
	  end

	  # This may be a backwards way to test, but makes sense to me.
	  it "@job#comments should include it" do
	  	@comment.save!
	  	expect(@job.comments).to include(@comment)
	  end

    it "should belong to a user" do
      expect(@comment.user).to be_a(User)
    end

  end

end
