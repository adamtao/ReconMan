include Warden::Test::Helpers
Warden.test_mode!

# Feature: View job info
#   As a processor
#   I want to view job details
#   So I can process and update the job
feature "View job details" do 

  before(:each) do
    @me = sign_in_as_processor
    @job = create(:tracking_job)
  end

  after(:each) do
    Warden.test_reset!
  end

  scenario "Property info appears in side panel"
  scenario "Links to client and requestor appear just below header"
  scenario "Header contains file number and edit/add buttons"
  scenario "Each job product has its own sub panel"
  scenario "Each job product panel can have uploaded documents"
  scenario "Document sub panel has inline file upload form"
  scenario "Each job product panel can have search history"
  scenario "Search history sub panel has inline log-search button"
  scenario "Each job product panel has info table on the right"
  scenario "Each job product panel has clearing/closing form on the left"

end
