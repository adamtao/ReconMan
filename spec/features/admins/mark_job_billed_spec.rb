require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Admin sees if a job_product is billed
#   As an admin
#   I want to see if a job_product is billed
#   So that I can bill the client if it isn't
feature "Toggle job_product billing status", :devise, :js do

  before do
    sign_in_as_admin
  end

  # Scenario: Show job_product as not billed
  scenario "not billed -> billed" do
    @tracking_job_product = FactoryGirl.create(:tracking_job_product)
    visit job_path(@tracking_job_product.job)

    check "Billed"

    sleep(1) # wait for ajax to go through
    @tracking_job_product.reload
    expect(@tracking_job_product.billed?).to be(true)
  end

  scenario "billed -> not billed" do
    @tracking_job_product = FactoryGirl.create(:tracking_job_product, billed: true)
    visit job_path(@tracking_job_product.job)

    uncheck "Billed"

    sleep(1) # wait for ajax to go through
    @tracking_job_product.reload
    expect(@tracking_job_product.billed?).to be(false)
  end
end
