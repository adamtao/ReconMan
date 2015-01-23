require 'rails_helper'

describe "jobs/_job_product.html.erb" do

  before do
    current_user = FactoryGirl.build_stubbed(:user, :admin)
    allow(view).to receive_messages(:current_user => current_user)

    @job_product = FactoryGirl.create(:tracking_job_product)
    @job_product.update_column(:price_cents, "1498")

    render partial: 'jobs/job_product', locals: { job_product: @job_product }
  end

  # most of this partial renders another partial:
  # job_products/_summary.html.erb
  # so check its specs for more.

  it "shows the title of the job product" do
    expect(rendered).to have_css(:h3, text: @job_product.product.name)
  end

  it "shows the price of the job product" do
    expect(rendered).to have_content("$14.98")
  end
end
