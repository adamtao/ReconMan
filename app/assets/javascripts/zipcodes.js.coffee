# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->

	#
	# When a zipcode is entered, send an AJAX request to the server to find
	# the city, state, county associated with that zipcode.
	#
	$('#job_zipcode').keyup ->
		zipcode = $('#job_zipcode').val()
		if zipcode.length > 4
			$.ajax
				url: "/zipcodes/#{ zipcode }.json"
				success: (data, status, response) ->
					# console.log data
					if data
						if data['primary_city']
							$('#job_city').val(data['primary_city'])
						if data['state_id']
							$('#job_state_id').val(data['state_id'])
						if data['county_id']
							$('#job_county_id').val(data['county_id'])
				dataType: 'json'

	#
	# Here's a good place to refactor some code. This is a sloppy
	# cut-and-paste of the function above. This one is used on the
	# client form, where the one above is on the job form.
	#
	$('#client_billing_zipcode').keyup ->
		zipcode = $('#client_billing_zipcode').val()
		if zipcode.length > 4
			$.ajax
				url: "/zipcodes/#{ zipcode }.json"
				success: (data, status, response) ->
					# console.log data
					if data
						if data['primary_city']
							$('#client_billing_city').val(data['primary_city'])
						if data['state_id']
							$('#client_billing_state_id').val(data['state_id'])
				dataType: 'json'
