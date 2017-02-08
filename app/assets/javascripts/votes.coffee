# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
 
  $('.vote-up').bind 'ajax:success', (e, data, status, xhr) ->
    $('#' + 'vote-' + data.id + ' .upvotes').html(data.count_upvotes) 

  $('.vote-down').bind 'ajax:success', (e, data, status, xhr) ->
    $('#' + 'vote-' + data.id + ' .downvotes').html(data.count_downvotes)   

  $('.vote-up, .vote-down').bind 'ajax:error', (e, data, status, xhr) -> 
    alert('You can\'t vote for you answer!')

  $('.vote-cancel').bind 'ajax:success', (e, data, status, xhr) ->
    $('#' + 'vote-' + data.id + ' .downvotes').html(data.count_downvotes)
    $('#' + 'vote-' + data.id + ' .upvotes').html(data.count_upvotes) 
