require 'rails_helper'

describe "tasks/_summary.html.erb" do

  before do
    current_user = FactoryGirl.build_stubbed(:user, :admin)
    allow(view).to receive_messages(:current_user => current_user)

    @task = FactoryGirl.create(:tracking_task)
    FactoryGirl.create(:search_log, task: @task)
    @document = FactoryGirl.create(:document, task: @task)

    render partial: 'tasks/summary', locals: { task: @task }
  end

  it "Each job product panel can have uploaded documents" do
    expect(rendered).to have_css(".documents-container")
  end

  it "Document sub panel has inline file upload form" do
    expect(rendered).to have_css("form.new_document")
  end

  it "links to uploaded documents" do
    expect(rendered).to have_link(@document.file_file_name)
  end

  it "has a delete icon for attached documents" do
    expect(rendered).to have_link("delete #{@document.file_file_name}", href: job_tracking_task_document_path(@task.job, @task, @document))
  end

  it "Each job product panel can have search history" do
    expect(rendered).to have_css(".search-history-container")
    expect(rendered).to have_content "Search History"
  end

  it "Each job product panel has clearing/closing form" do
    expect(rendered).to have_css("form.edit_tracking_task")
    expect(rendered).to have_content("Release Number")
  end

  it "Each job product panel has info table" do
    expect(rendered).to have_content @task.deed_of_trust_number
    expect(rendered).to have_content @task.beneficiary_name
  end
end
