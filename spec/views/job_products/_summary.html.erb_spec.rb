require 'rails_helper'

describe "job_products/_summary.html.erb" do

  before do
    current_user = FactoryGirl.build_stubbed(:user, :admin)
    allow(view).to receive_messages(:current_user => current_user)

    @job_product = FactoryGirl.create(:tracking_job_product)
    FactoryGirl.create(:search_log, job_product: @job_product)

    render partial: 'job_products/summary', locals: { job_product: @job_product }
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

  it "Each job product panel has clearing/closing form" do
    expect(rendered).to have_css("form.edit_job_product")
    expect(rendered).to have_content("Release Number")
  end

  it "Each job product panel has info table" do
    expect(rendered).to have_content @job_product.deed_of_trust_number
    expect(rendered).to have_content @job_product.beneficiary_name
  end
end
