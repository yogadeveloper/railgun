# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show();

  PrivatePub.subscribe "/questions", (data, channel) ->
    question = $.parseJSON(data['question'])
    $('.questions-list').append("<div id=question-#{question.id}><div class=page-header>
                <h3><a href=/questions/#{question.id}>" + question.title + '</a></h1></div></div>')

  PrivatePub.subscribe "/questions/destroy", (data, channel) ->
    console.log(data)
    question = $.parseJSON(data['question'])
    $('div#question-' + question.id).remove()

  $('.comment-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('form#new-comment-Question-' + question_id).show();

  $('.add-attachment-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('div#attachments').show();

  $('input[value="Reply"]').click (e) ->
    $('div#attachments').hide();
    $('.add-attachment-link').show();

  $('input[value="Save"]').click (e) ->
    $('div#attachments').hide();
    $('.add-attachment-link').show();

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
