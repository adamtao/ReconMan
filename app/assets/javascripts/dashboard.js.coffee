# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->

	$('input.completer').prop("checked", false).each -> new Completer(@) 
	$('input.incompleter').prop("checked", true).each -> new Completer(@)

class Completer

	constructor: (checkbox) ->
		@checkbox = $(checkbox)
		@job_id = @checkbox.data('job') 
		@product_id = @checkbox.data('job_product')
		@checkbox.click () =>
			# if @checkbox.hasClass('completer') then @complete() else @uncomplete()
			@update_database()

	update_database: ->
		$.ajax "/jobs/#{@job_id}/job_products/#{@product_id}/toggle.js"

	# complete: ->
	# 	@checkbox.removeClass('completer').addClass('incompleter')
	# 	$("#task_row_#{@task_id}").fadeOut 'fast', ->
	# 		$(@).find('input').prop("checked", true)
	# 		if $(@).is('li')
	# 			$(@).find('i').hide()
	# 			$(@).find('.assigned').html('Completed: just now')
	# 			$(@).prependTo('ul#completed-tasks').fadeIn('fast')
	# 		else
	# 			$(@).find('td.date').html('just now')
	# 			$(@).prependTo('table#completed-tasks tbody').show()
	
	# uncomplete: ->
	# 	@checkbox.removeClass('incompleter').addClass('completer')
	# 	$("#task_row_#{@task_id}").fadeOut 'fast', ->
	# 		$(@).find('input').prop("checked", false)
	# 		if $(@).is('li')
	# 			$(@).find('i').show()
	# 			label = if w == 'Unassigned' then "<span class='alert round label'>#{w}</span>" else "Assigned to: #{w}"
	# 			$(@).find('.assigned').html(label)
	# 			$(@).prependTo('ul#incomplete-tasks').fadeIn('fast')			
	# 		else
	# 			$(@).find('td.date').html(d)
	# 			$(@).prependTo('table#incomplete-tasks tbody').show()		
		
