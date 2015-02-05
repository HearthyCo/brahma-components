Backbone = require 'exoskeleton'
_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'

SessionStore = require '../stores/SessionStore'


conf =
  endpoint: '/v1/user/home'

HomeState =
  data:
    sessions:
      programmed: Object.create(SessionStore)
      underway: Object.create(SessionStore)
      closed: Object.create(SessionStore)
  # TODO: Add other sections...


_.extend HomeState, Backbone.Events

HomeState.addChangeListener = (callback) ->
  HomeState.on 'change', callback

HomeState.removeChangeListener = (callback) ->
  HomeState.off 'change', callback

HomeState.getAll = ->
  sessions:
    programmed: HomeState.data.sessions.programmed.getAll()
    underway: HomeState.data.sessions.underway.getAll()
    closed: HomeState.data.sessions.closed.getAll()


parseResponse = (response) ->
  for state of HomeState.data.sessions
    HomeState.data.sessions[state].reset(response.sessions[state])


AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'home:refresh'
      Backbone.ajax
        dataType: 'jsonp'
        url: window.apiServer + conf.endpoint
        success: (response) ->
          console.log 'Downloaded new home info:', response
          parseResponse response
          HomeState.trigger 'change'
        error: (xhr, status) ->
          console.log 'Error loading home info:', status, xhr

module.exports = HomeState