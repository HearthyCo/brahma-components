Backbone = require 'exoskeleton'
_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'

SessionStore = require './SessionStore'


conf =
  endpoint: '/v1/user/sessions'

SessionsStore =
  programmed: Object.create SessionStore
  underway: Object.create SessionStore
  closed: Object.create SessionStore

SessionsStore.programmed.url = conf.endpoint + '/programmed'
SessionsStore.underway.url = conf.endpoint + '/underway'
SessionsStore.closed.url = conf.endpoint + '/closed'


_.extend SessionsStore, Backbone.Events

SessionsStore.addChangeListener = (callback) ->
  SessionsStore.on 'change', callback

SessionsStore.removeChangeListener = (callback) ->
  SessionsStore.off 'change', callback


AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'sessions:refresh'
      target = payload.section
      if not SessionsStore[target]
        console.log 'Unknown section sessions[' + target + ']'
        return
      SessionsStore[target].fetch(
        reset: true
        success: (sessions) ->
          msg = 'Downloaded new sessions[' + target + '] info:'
          console.log msg, sessions.toJSON()
          SessionsStore.trigger 'change'
        error: (xhr, status) ->
          msg = 'Error loading sessions[' + target + '] info:'
          console.log msg, status, xhr
      )

module.exports = SessionsStore