require 'rails_helper'

describe "reports/index.html.erb" do

  before do
    current_user = FactoryGirl.build_stubbed(:user, :admin)
    allow(view).to receive_messages(:current_user => current_user)
    FactoryGirl.create_list(:client, 2)
    FactoryGirl.create_list(:lender, 2)
    @report = Report.new
    assign(:report, @report)

    render
  end

  it "has a report builder form" do
    expect(rendered).to have_css("form.new_report")
    expect(rendered).to have_css("input.button[type=submit]")
  end

  it "has a client dropdown" do
    expect(rendered).to have_css("select#report_client_id")
  end

  it "has a start and end date" do
    expect(rendered).to have_css("input#report_start_on")
    expect(rendered).to have_css("input#report_end_on")
  end

  it "has lender fields" do
    expect(rendered).to have_css("select#report_lender_id")
  end

  it "has job status field" do
    pending "other spec"
    expect(rendered).to have_css("input#report_job_product_status")
  end

end
