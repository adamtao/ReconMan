require 'rails_helper'

describe "counties/show.html.erb" do

  before do
    @current_user = build_stubbed(:user, :admin)
    allow(view).to receive_messages(:current_user => @current_user)
    @county = create(:county)
    @tracking_jobs = create_list(:tracking_job, 3, county: @county)
    assign(:state, @county.state)
    assign(:county, @county)
  end

  context "checked out" do
    before do
      @processor = create(:user, :processor)
      @county.checkout_to(@processor)
      render
    end

    it "shows who has it checked out" do
      expect(rendered).to have_content("Checked out to #{@processor.name}")
    end
  end

  context "standard" do
    before do
      render
    end

    it "doesn't show checkout info" do
      expect(rendered).not_to have_content("Checked out to")
    end
  end
end
