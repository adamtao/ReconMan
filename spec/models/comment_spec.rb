describe Comment do

  describe "on jobs" do 

	  before(:each) do 
	  	@job = create(:job)
	  	@comment = build(:comment, related_type: "Job", related_id: @job.id) 
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

  end

end
