# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->

  hide_report_dates = ->
    if $('select#report_job_status').val() == 'Complete'
      $('input.datepicker').closest('div.input').show()
    else
      $('input.datepicker').closest('div.input').hide()

  if $('select#report_job_status').length > 0
    hide_report_dates()
    $('select#report_job_status').change -> hide_report_dates()
