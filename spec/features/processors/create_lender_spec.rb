include Warden::Test::Helpers
Warden.test_mode!

# Feature: Create lender
#   As a processor
#   I want to create a lender
#   So I can add that lender to a job
feature "Create lender" do
  before(:each) do
    sign_in_as_processor
  end

  after(:each) do
    Warden.test_reset!
  end

  scenario 'successfully' do
    visit new_lender_path

    fill_in 'Name', with: "Something Cool"
    click_on "Create Lender"

    expect(page).to have_css("h1", text: "Something Cool")
  end
end

feature "Edit lender" do
  before(:each) do
    @lender = create(:lender, name: "Mr. Foo's Lending")
    sign_in_as_processor
    visit lender_path(@lender)
  end

  after(:each) do
    Warden.test_reset!
  end

  scenario "Visiting a lender should have an edit button" do
    expect(page).to have_link("Edit Lender", href: edit_lender_path(@lender))
  end

  scenario "Edit button should take you to working lender edit form" do
    click_on "Edit Lender"
    fill_in "Name", with: "Mr. Goo's Lending"
    click_on "Update Lender"

    expect(page).to have_content("Mr. Goo's Lending")
    expect(page).not_to have_content("Mr. Foo's Lending")
  end
end
