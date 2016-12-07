# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
 

  $('.vote-up, .vote-down').bind 'ajax:success', (e, data, status, xhr) ->
    $('#' + 'vote-' + data.votable_type.toLowerCase() + '-' + data.votable_id + ' .rating').html(data.count_votes)

  $('.vote-up, .vote-down').bind 'ajax:error', (e, data, status, xhr) -> 
    alert('error')

  $('.vote-cancel').bind 'ajax:success', (e, data, status, xhr) ->
    $('#' + 'vote-' + data.votable_type.toLowerCase() + '-' + data.votable_id + ' .rating').html(data.count_votes)