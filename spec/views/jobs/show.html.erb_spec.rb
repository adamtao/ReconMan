require 'rails_helper'

describe "jobs/show.html.erb" do

  before do
    @current_user = FactoryGirl.build_stubbed(:user, :processor)
    allow(view).to receive_messages(:current_user => @current_user)
    @job = FactoryGirl.create(:tracking_job, address: "123 street")
    @job2 = FactoryGirl.create(:tracking_job, county: @job.county)
    assign(:job, @job)
    assign(:comment, FactoryGirl.build_stubbed(:comment))
  end

  context "standard view" do
    before do
      render
    end

    it "Property info appears in side panel" do
      expect(rendered).to have_css(".side_content h2", text: "Property Information")
      expect(rendered).to have_css(".side_content", text: '123 street')
    end

    it "Links to client and requestor appear just below header" do
      expect(rendered).to have_link(@job.client.name, href: client_path(@job.client))
    end

    it "Header contains file number and edit/add buttons" do
      job_header = Capybara.string(rendered).find(".job-header")

      expect(job_header).to have_css("h2", text: "File: #{@job.file_number}")
      expect(job_header).to have_link("Add product", href: new_job_task_path(@job))
    end

    it "Each job product has its own sub panel" do
      job_container = Capybara.string(rendered).find(".main_content")

      expect(job_container).to have_css(".task-container", count: @job.tasks.length)
    end

    it "shows the job status" do
      expect(rendered).to have_css("p", text: "Job Status:")
    end

    it "The job total appears" do
      expect(rendered).to have_content("total: $")
    end

    it "won't link to next job" do
      expect(rendered).not_to have_link("next job", href: job_path(@job2))
    end
  end

  context "with county checked out" do
    before do
      @current_user.checkout_county(@job.county)

      render
    end

    it "shows a next button" do
      skip "Not sure what this was supposed to do (2/8/2017)"
      puts rendered
      expect(rendered).to have_link("next job", href: job_path(@job2))
    end

  end
end
