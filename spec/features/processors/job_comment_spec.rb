require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Create client
#   As a processor
#   I want to add a comment to a Job
feature 'Comment on a Job', :devise do

  before(:all) do
    @job = create(:job)
  end

	before(:each) do
		@me = sign_in_as_processor
	end

  after(:each) do
    Warden.test_reset!
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
  end
	# Scenario: Processor posts a comment
	# 	Given I complete the comment form
	#   When I submit the form
	#   Then I see my comment on the Job page
	scenario 'post a comment' do
		msg = "The quick fox ate a sandwich"
		visit job_path(@job)

		fill_in 'comment_message', with: msg
		click_on 'Save Comment'

		expect(page).to have_content(msg)
	end

	# Scenario: Processor edits the last comment
	# 	Given I posted a comment
	#   And my comment is last
	#   When I edit the comment
	#   Then I see the modified message on the Job page
	scenario 'edit the last comment' do
		preload_my_comment
		msg = @comment.message + "The quick fox ate a sandwich"
		visit job_path(@job)

		click_on 'Edit Comment'
		fill_in 'comment_message', with: msg
		click_on 'Save Comment'

		expect(page).to have_content(msg)
	end

	# Scenario: Processor edits another user comment
	# 	Given someone else posted a comment
	#   When I try to edit the comment
	#   The link to edit is missing
	scenario 'cannot edit another user comment' do
		add_another_comment
		visit job_path(@job)

		expect(page).not_to have_link('Edit Comment')
	end

	# Scenario: Processor edits a non-last comment
	# 	Given I posted a comment
	#   And someone else posts a response
	#   When I try to edit the comment
	#   The link to edit is missing
	scenario 'cannot edit old comment' do
		preload_my_comment
		add_another_comment
		visit job_path(@job)

		expect(page).not_to have_link('Edit Comment', href: edit_comment_path(@comment))
	end

	# Scenario: Processor deletes the last comment
	# 	Given I posted a comment
	#   And my comment is last
	#   When I delete the comment
	#   Then the message does not appear on the Job page
	scenario 'delete the last comment' do
		preload_my_comment
		visit job_path(@job)

		click_on 'Delete Comment'

		expect(page).not_to have_content(@comment.message)
	end

	# Scenario: Processor deletes another user comment
	# 	Given someone else posted a comment
	#   When I try to edit the comment
	#   The link to edit is missing
	scenario 'cannot delete another user comment' do
		add_another_comment
		visit job_path(@job)

		expect(page).not_to have_link('Delete Comment')
	end

	# Scenario: Processor deletes a non-last comment
	# 	Given I posted a comment
	#   And someone else posts a response
	#   When I try to delete the comment
	#   The link to delete is missing
	scenario 'cannot delete old comment' do
		preload_my_comment
		add_another_comment
		visit job_path(@job)

		expect(page).not_to have_link('Delete Comment')
	end

	def preload_my_comment
		@comment = create(:comment, related_id: @job.id, related_type: @job.class.name, user: @me)
	end

	def add_another_comment
    create(:comment, related_id: @job.id, related_type: @job.class.name, created_at: 1.day.from_now)
	end

end
