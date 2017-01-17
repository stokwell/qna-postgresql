# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.add-btn').click (e) ->
    e.preventDefault();
    $('.new-answer-form').show() 

  $('.new_answer_link').click () ->
    $('.new_answer_form').show()
    $('#clear').focus();

  



$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()
     
  
  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      console.log 'connected!'
      @perform 'follow'

    received: (data) ->
      console.log 'Received!', data
      answer = $.parseJSON(data)
      console.log(gon.user_id)
      $('.answers').append(JST["answer"]({answer: answer}));
  })  