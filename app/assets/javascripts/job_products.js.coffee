# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

	show_url_field = ->
		search_url_field = $("form#new_job_product #job_product_search_url")
		selected_product_id = parseInt($("form#new_job_product #job_product_product_id option").filter(':selected').val())
		if selected_product_id == parseInt(search_url_field.data('product'))
			search_url_field.parent().show() 
		else
			search_url_field.parent().hide()

	show_url_field()

	$("#job_product_product_id").change -> show_url_field()
	

	set_price = ->
		pr = $("#job_product_product_id option").filter(':selected').data('price')
		$('#job_product_price').val(pr)

	set_price()

	$('#job_product_product_id').change -> set_price()

	$('form').on 'click', '.remove_fields', (event) ->
		$(@).prev('input[type=hidden]').val('1')
		$(@).closest('div.row').hide()
		event.preventDefault()

	$('form').on 'click', '.add_fields', (event) ->
		time = new Date().getTime()
		regexp = new RegExp($(@).data('id'), 'g')
		$(@).closest('div.row').before($(@).data('fields').replace(regexp, time))
		event.preventDefault()
