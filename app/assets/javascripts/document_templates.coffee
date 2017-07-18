# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ($) ->

  if $('#content_editor').length
    template_code = $('#document_template_content').val()
    $('#document_template_content').hide()
    editor = ace.edit("content_editor")
    editor.setTheme("ace/theme/textmate")
    editor.getSession().setMode("ace/mode/liquid")
    editor.setValue(template_code)
    editor.gotoLine(1)

    $('form#edit_document_template').submit ->
      $('#document_template_content').val(editor.getValue())

