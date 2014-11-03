require 'rails_helper'

describe "reports/show.html.erb" do

  before do
    current_user = FactoryGirl.build_stubbed(:user, :admin)
    allow(view).to receive_messages(:current_user => current_user)
    @tracking_job_product = FactoryGirl.create(
      :tracking_job_product,
      workflow_state: 'complete',
      recorded_on: 2.weeks.ago,
      cleared_on: 1.week.ago,
      deed_of_trust_number: "032983j-qw9897-498v3",
      new_deed_of_trust_number: "089786-349204-234u20"
    )
    @tracking_job_product.reload
    @job = @tracking_job_product.job
    @client = @job.client
    @report = Report.new(
      client_id: @client.id,
      start_on: 1.month.ago,
      end_on: 1.day.ago,
      job_status: 'complete'
    )
    assign(:report, @report)

    render
  end

  it "should have a relevant title" do
    expect(rendered).to have_content "Complete Jobs For #{@client.name}"
  end

  it "should have report headers" do
    t = Capybara.string(rendered).find("table#jobs thead tr:eq(1)")

    expect(t).to have_css("th:eq(1)", text: "File")
    expect(t).to have_css("th:eq(2)", text: "Client")
    expect(t).to have_css("th:eq(3)", text: "Escrow Officer")
    expect(t).to have_css("th:eq(4)", text: "Close Date")
    expect(t).to have_css("th:eq(5)", text: "Lender")
    expect(t).to have_css("th:eq(6)", text: "DOT #")
    expect(t).to have_css("th:eq(7)", text: "Release #")
    expect(t).to have_css("th:eq(8)", text: "Release Date")
  end

  it "should have report columns" do
    t = Capybara.string(rendered).find("table#jobs tbody tr:eq(1)")

    expect(t).to have_css("td:eq(1)", text: @job.file_number)
    expect(t).to have_css("td:eq(2)", text: @client.name)
    expect(t).to have_css("td:eq(3)", text: @job.requestor.name)
    expect(t).to have_css("td:eq(4)", text: @job.close_on.to_s)
    expect(t).to have_css("td:eq(5)", text: @tracking_job_product.lender.name)
    expect(t).to have_css("td:eq(6)", text: @tracking_job_product.deed_of_trust_number)
    expect(t).to have_css("td:eq(7)", text: @tracking_job_product.new_deed_of_trust_number)
    expect(t).to have_css("td:eq(8)", text: @tracking_job_product.recorded_on.to_s)
  end

end
