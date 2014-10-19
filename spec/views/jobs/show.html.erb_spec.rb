describe "jobs/show.html.erb" do

  before do
    current_user = FactoryGirl.build_stubbed(:user, :processor)
    allow(view).to receive_messages(:current_user => current_user)
    @job = FactoryGirl.create(:tracking_job, address: "123 street")
    assign(:job, @job)
    assign(:comment, FactoryGirl.build_stubbed(:comment))

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
    expect(job_header).to have_link("Add product", href: new_job_job_product_path(@job))
  end

  it "Each job product has its own sub panel" do
    job_container = Capybara.string(rendered).find(".main_content")

    expect(job_container).to have_css(".job-product-container", count: @job.job_products.length)
  end

  it "shows the job status" do
    expect(rendered).to have_css("p", text: "Job Status:")
  end
  it "The job total appears" do
    expect(rendered).to have_content("total: $")
  end
end
