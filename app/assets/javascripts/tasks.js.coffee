# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

  show_url_field = ->
    $search_url_field = $("input#task_search_url")
    $product_selector = $("select#task_product_id")
    unless !$product_selector.length
      product_ids = $search_url_field.data('products').toString().split(',')
      selected_product_id = $("#task_product_id option").filter(':selected').val()
      if selected_product_id == product_ids or selected_product_id in product_ids
        #console.log("SHOW URL Product ids are: #{ product_ids }")
        $search_url_field.parent().show()
      else
        #console.log("HIDE URL Product ids are: #{ product_ids }")
        $search_url_field.parent().hide()

  show_product_fields = ->
    selected_product_id = $("#task_product_id option").filter(':selected').val()
    $('.product-specific-fields').each ->
      product_ids = $(@).data('products').toString().split(',')
      if selected_product_id > 0 and (selected_product_id == product_ids or selected_product_id in product_ids)
        #console.log("SHOW Product ids are: #{ product_ids }")
        $(@).show()
        $('div.task_lender_name').hide()
      else
        #console.log("HIDE Product ids are: #{ product_ids }")
        $(@).hide()

  show_url_field()
  show_product_fields()

  $("#task_product_id").change ->
    show_url_field()
    show_product_fields()

  set_price = ->
    pr = $("#task_product_id option").filter(':selected').data('price')
    $('#task_price').val(pr)

  set_price()

  $('#task_product_id').change -> set_price()

  $('div.job_tasks_lender_name').hide()
  $('div.task_lender_name').hide()

  $('form').on 'click', '.toggle-lender', (e) ->
    e.preventDefault()
    original_link_text = $(@).html()
    if original_link_text == "new lender"
      $(@).html('select existing lender')
    else
      $(@).html('new lender')
    $(@).closest('div.row').find('div.job_tasks_lender_name').toggle()
    $(@).closest('div.row').find('div.task_lender_name').toggle()
    $(@).closest('div.row').find('div.job_tasks_lender').toggle()
    $(@).closest('div.row').find('div.task_lender').toggle()

  $('form').on 'click', '.remove_fields', (event) ->
    $(@).closest('div.item-fields').find('input[type=hidden].deleter').val('1')
    $(@).closest('div.item-fields').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(@).data('id'), 'g')
    new_elem = $(@).data('fields').replace(regexp, time)
    $(@).closest('div.row').before(new_elem)
    $(@).closest('div.row').parent().find('div.job_tasks_lender_name').last().hide()
    event.preventDefault()

  $('form').on 'click', 'input.toggle-billing', (event) ->
    item_id = $(@).data('id')
    $.post("/tasks/#{item_id}/toggle_billing")


