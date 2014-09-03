# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->

	$('.datepicker').datepicker
		inline: true
		numberOfMonths: 2
		showButtonPanel: true	
		dateFormat: "DD, MM d, yy"
		constrainInput: true

	# Automatically shows/hides options from a dependent html select based
	# on the selected option of another.
	#
	# Usage:
	#   new OptionFilter('#primary_select_id', '#dependent_select_id')
	#
	# The options for the dependent select needs to be grouped by options found
	# in the primary select. The simple_form gem for rails does it like so:
	#
	#  <%= simple_form_for(@job) do |f| %>
	#    ...
	#    <%= f.association :state, collection: State.all %>
	#    <%= f.association :county, collection: State.all, as: :grouped_select, group_method: :counties %>
	#    ...
	#  <% end %>
	#
	#  Given the "simple_form" above, the counties could be made dependent on the states like so...
	#
	#    new OptionFilter('#job_state_id', '#job_county_id')
	#
	class OptionFilter

		constructor: (@primary, @dependent) ->
			@all_dependent_options = $(@dependent).html()
			@setup_hidden_container()
			primary_selected = $("#{ @primary } option").filter(':selected').text()
			@handle_change()

		handle_change: =>
			$(@primary).change =>
				@filter_results()

		filter_results: =>
			primary_selected = $("#{ @primary } option").filter(':selected').text()
			escaped_selected = primary_selected.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
			options_to_show = $(@all_dependent_options).filter("optgroup[label=#{ escaped_selected }]").html()
			if options_to_show
				$(@dependent).html(options_to_show)
				@hidden_container.show()
			else
				$(@dependent).empty()
				@hidden_container.hide()

		setup_hidden_container: =>
			@hidden_container = $(@dependent).parent()
			@hidden_container.hide() unless $("#{ @primary } option").filter(':selected').val() > 0

	# Instantiate the related options filters
	#new OptionFilter('#job_state_id', '#job_county_id')
	r_filter = new OptionFilter('#job_client_id', '#job_requestor_id')

	r_filter.filter_results() if $('#job_client_id').val() > 0
