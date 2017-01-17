# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.add-btn').click (e) ->
    e.preventDefault();
    $('.new-question-form').show() 


  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide()
    $('.edit_question').show() 

  App.cable.subscriptions.create('QuestionsChannel', {
  	connected: ->
  	  console.log 'connected!'
  	  @perform 'follow'

  	received: (data) ->
      $('.questions-list').append data
  })  
    