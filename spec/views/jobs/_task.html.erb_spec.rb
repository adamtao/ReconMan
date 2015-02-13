require 'rails_helper'

describe "jobs/_task.html.erb" do

  before do
    current_user = FactoryGirl.build_stubbed(:user, :admin)
    allow(view).to receive_messages(:current_user => current_user)

    @task = FactoryGirl.create(:tracking_task)
    @task.update_column(:price_cents, "1498")

    render partial: 'jobs/task', locals: { task: @task }
  end

  # most of this partial renders another partial:
  # tasks/_summary.html.erb
  # so check its specs for more.

  it "shows the title of the job product" do
    expect(rendered).to have_css(:h3, text: @task.product.name)
  end

  it "shows the price of the job product" do
    expect(rendered).to have_content("$14.98")
  end
end
