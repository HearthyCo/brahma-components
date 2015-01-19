Backbone = require 'exoskeleton'
_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'

conf =
  endpoint: '/v1/home'

HomeState =
  data:
    sessions:
      programmed: []
      underway: []
      closed: []
  # TODO: Add other sections...

_.extend HomeState, Backbone.Events

HomeState.addChangeListener = (callback) ->
  HomeState.on 'change', callback

HomeState.removeChangeListener = (callback) ->
  HomeState.off 'change', callback


AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'home:refresh'
      Backbone.ajax
        dataType: 'jsonp'
        url: conf.endpoint
        success: (response) ->
          console.log 'Downloaded new home info:', response
          HomeState.data = response
          HomeState.trigger 'change'
        error: (xhr, status) ->
          console.log 'Error loading home info:', status, xhr

module.exports = HomeState