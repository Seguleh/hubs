# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->

  oTable = $('#results-table').dataTable
    bAutoWidth: true
    stateSave: true
    scrollCollapse: true
    pagingType: 'full_numbers'
    ordering: true
    bPaginate: true
    bFilter: true
    processing: true
    serverSide: true
    ajax: $('#results-table').data('source')
    columns: [
      {data: 'country_code'}
      {data: 'locode'}
      {data: 'name'}
      {data: 'function'}
      {data: 'status'}
      {data: 'iata'}
      {data: 'lat'}
      {data: 'lon'}
    ]

$(document).ready(ready)
$(document).on('page:load', ready)
