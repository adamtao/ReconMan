require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature "Log a title search" do

  before(:each) do
    @me = sign_in_as_processor
    @job = create(:tracking_job)
  end

  scenario "(not cleared) successfully" do
    visit job_path(@job)

    click_on 'Log Search'

    expect(page).to have_css("ul.log li", text: @me.name)
    expect(page).to have_css("ul.log li", text: '|Not Cleared')
  end

  scenario "(cleared) successfully" do
    visit job_path(@job)

    check 'Cleared'
    click_on 'Log Search'

    expect(page).to have_css("ul.log li", text: @me.name)
    expect(page).to have_css("ul.log li", text: "|Cleared")
  end
end

