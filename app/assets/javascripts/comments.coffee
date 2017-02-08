# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.show-comments-btn').click (e) ->
    e.preventDefault();
    comments_box = $(this).attr('id')
    console.log (comments_box)
    $('.comments-box').hide()
    $('#' + 'comments-box-' + comments_box).show()

    $('textarea').focus() 

  $('.edit-comment-form-btn').click (e) ->
    e.preventDefault();


   App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      console.log 'connected!'
      @perform 'follow'

    received: (data) ->
      console.log 'Received!', data
      comment = $.parseJSON(data)
      $('#comments-box-' + comment.answer_id).append(JST["comment"]({comment: comment}));
  })    
    
    