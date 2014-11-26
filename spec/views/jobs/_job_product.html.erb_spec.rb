require 'rails_helper'

describe "jobs/_job_product.html.erb" do

  before do
    current_user = FactoryGirl.build_stubbed(:user, :admin)
    allow(view).to receive_messages(:current_user => current_user)

    @job_product = FactoryGirl.create(:tracking_job_product)

    render partial: 'jobs/job_product', locals: { job_product: @job_product }
  end

  it "Each job product panel can have uploaded documents" do
    expect(rendered).to have_css(".documents-container")
  end

  it "Document sub panel has inline file upload form" do
    expect(rendered).to have_css("form.new_document")
  end

  it "Each job product panel can have search history" do
    expect(rendered).to have_css(".search-history-container")
    expect(rendered).to have_content "Search History"
  end

  it "Search history sub panel has inline log-search button" do
    expect(rendered).to have_button "Log Search"
  end

  it "Each job product panel has info table" do
    expect(rendered).to have_content @job_product.deed_of_trust_number
    expect(rendered).to have_content @job_product.beneficiary_name
  end

  it "Each job product panel has clearing/closing form" do
    expect(rendered).to have_css("form.edit_job_product")
    expect(rendered).to have_content("Release Number")
  end

end
