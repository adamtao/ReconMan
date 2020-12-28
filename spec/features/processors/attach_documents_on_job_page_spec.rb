require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature "Attach document on job page", :devise do

  before(:each) do
    @me = sign_in_as_processor
    @job = create(:tracking_job)
    @tempfile = Rails.root.join("spec", "fixtures", "test_file.doc")
    visit job_path(@job)
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
  end

  after do
    Warden.test_reset!
  end

  scenario "successfully" do
    attach_file 'document_file', @tempfile
    click_on 'Upload'

    expect(page).to have_link("test_file.doc")
  end
end
