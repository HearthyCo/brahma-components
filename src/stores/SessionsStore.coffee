Backbone = require 'exoskeleton'
_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'

SessionStore = require './SessionStore'


conf =
  endpoint: '/me/sessions'

SessionsStore =
  programmed: Object.create SessionStore
  underway: Object.create SessionStore
  closed: Object.create SessionStore

getApiFor = (tag) -> -> window.apiServer + conf.endpoint + tag
SessionsStore.programmed.url = getApiFor '/programmed'
SessionsStore.underway.url = getApiFor '/underway'
SessionsStore.closed.url = getApiFor '/closed'


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