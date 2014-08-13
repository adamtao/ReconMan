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
		@product_id = @checkbox.data('job-product')
		@checkbox.click () =>
			if @checkbox.hasClass('completer') then @complete() else @uncomplete()
			@update_database()

	update_database: ->
		$.ajax "/jobs/#{@job_id}/job_products/#{@product_id}/toggle.js"

	complete: ->
		@checkbox.removeClass('completer').addClass('incompleter')
		$("tr#job_#{@job_id}").fadeOut 'fast', ->
			$(@).find('input').prop("checked", true)
			$(@).find('td:last').html('just now')
			$(@).prependTo('table#completed-jobs tbody').fadeIn().effect("highlight")
	
	uncomplete: ->
		@checkbox.removeClass('incompleter').addClass('completer')
		$("tr#job_#{@job_id}").fadeOut 'fast', ->
			$(@).find('input').prop("checked", false)
			$(@).find('td:last').html('re-opened')
			$(@).prependTo('table#incomplete-jobs tbody').fadeIn().effect("highlight")
		
