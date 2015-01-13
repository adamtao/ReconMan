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
    @branch = FactoryGirl.create(:branch, client: @client)
    @requestor = @job.requestor
    @requestor.update_column(:branch_id, @branch.id)

    @report = Report.new(
      client_id: @client.id,
      start_on: 1.month.ago,
      end_on: 1.day.ago,
      job_status: 'complete'
    )
  end

  it "should have a relevant title" do
    get_report

    expect(rendered).to have_content "Complete Jobs For #{@client.name}"
  end

  it "should have report headers" do
    get_report

    expect(table_header).to have_css("th:eq(1)", text: "File")
    expect(table_header).to have_css("th:eq(2)", text: "County")
    expect(table_header).to have_css("th:eq(3)", text: "State")
    expect(table_header).to have_css("th:eq(4)", text: "Client")
    expect(table_header).to have_css("th:eq(5)", text: "Escrow Officer")
    expect(table_header).to have_css("th:eq(6)", text: "Close Date")
    expect(table_header).to have_css("th:eq(7)", text: "Lender")
    expect(table_header).to have_css("th:eq(8)", text: "DOT #")
    expect(table_header).to have_css("th:eq(9)", text: "Release #")
    expect(table_header).to have_css("th:eq(10)", text: "Release Date")
  end

  it "should have report columns" do
    get_report

    expect(table_row).to have_css("td:eq(1)", text: @job.file_number)
    expect(table_row).to have_css("td:eq(2)", text: @job.county.name)
    expect(table_row).to have_css("td:eq(3)", text: @job.state.abbreviation)
    expect(table_row).to have_css("td:eq(4)", text: @client.name)
    expect(table_row).to have_css("td:eq(5)", text: @job.requestor.name)
    expect(table_row).to have_css("td:eq(6)", text: @job.close_on.to_s)
    expect(table_row).to have_css("td:eq(7)", text: @tracking_job_product.lender.name)
    expect(table_row).to have_css("td:eq(8)", text: @tracking_job_product.deed_of_trust_number)
    expect(table_row).to have_css("td:eq(9)", text: @tracking_job_product.new_deed_of_trust_number)
    expect(table_row).to have_css("td:eq(10)", text: @tracking_job_product.recorded_on.to_s)
  end

  describe "with incomplete jobs" do
    before do
      JobProduct.update_all(workflow_state: 'in_progress')
      @tracking_job_product.reload
      @report.job_status = "In Progress"
      @report.show_pricing = false
      get_report
    end

    it "shows the first notice column" do
      expect(table_header).to have_css("th:eq(11)", text: "1st Notice")
      expect(table_row).to have_css("td:eq(11)", text: @tracking_job_product.first_notice_date)
    end

    it "shows the second notice column" do
      expect(table_header).to have_css("th:eq(12)", text: "2nd Notice")
      expect(table_row).to have_css("td:eq(12)", text: @tracking_job_product.second_notice_date)
    end
  end

  describe "complete jobs and pricing" do
    before do
      JobProduct.update_all(workflow_state: 'complete')
      @tracking_job_product.reload
      @report.job_status = "Complete"
      @report.show_pricing = true
      get_report
    end

    it "has the branch columns" do
      expect(table_header).to have_css("th:eq(11)", text: "Branch")
      expect(table_row).to have_css("td:eq(11)", text: @branch.name)
    end

    it "should have pricing column" do
      expect(table_header).to have_css("th:eq(12)", text: "Price")
      expect(table_row).to have_css("td:eq(12)", text: @tracking_job_product.price)
    end

    it "should have the grand total row" do
      expect(table_footer).to have_css("td", text: "Total")
      expect(table_footer).to have_css("td", text: @report.total)
    end
  end

  def get_report
    assign(:report, @report)
    render
  end

  def table_header
    @table_header ||= Capybara.string(rendered).find("table#jobs thead tr:eq(1)")
  end

  def table_row
    @table_row ||= Capybara.string(rendered).find("table#jobs tbody tr:eq(1)")
  end

  def table_footer
    @table_footer ||= Capybara.string(rendered).find("table#jobs tfoot tr:eq(1)")
  end

end
