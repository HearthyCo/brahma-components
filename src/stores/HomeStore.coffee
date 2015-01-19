Backbone = require 'exoskeleton'
_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'

conf =
  endpoint: '/v1/home'

HomeState =
  data:
    sessions: # TODO: This should be empty
      programmed: [
        {id: 1, title: 'Bird', startDate: new Date(1422019364000), isNew: false}
        {id: 2, title: 'Boy', startDate: new Date(1424092964000), isNew: false}
      ]
      underway: [
        {id: 3, title: 'Flesh', startDate: new Date(1421414564000), isNew: true}
        {id: 4, title: 'Home', startDate: new Date(1421413764000), isNew: false}
      ]
      closed: [
        {id: 5, title: 'Neat', startDate: new Date(1419034861000), isNew: true}
        {id: 6, title: 'Reap', startDate: new Date(1417162438000), isNew: true}
      ]
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