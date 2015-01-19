Backbone = require 'exoskeleton'
_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'

Session = require './SessionStore'

conf =
  endpoint: '/v1/user/sessions'

Sessions = Backbone.Collection.extend
  model: Session
  url: -> conf.endpoint + '/' + @kind
  parse: (o) -> o.sessions
  initialize: (models, kind) ->
    @kind = kind

SessionsStore =
  programmed: new Sessions [], 'programmed'
  underway: new Sessions [], 'underway'
  closed: new Sessions [], 'closed'

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
        success: (sessions) ->
          msg = 'Downloaded new sessions[' + target + '] info:'
          console.log msg, sessions
          SessionsStore.trigger 'change'
        error: (xhr, status) ->
          msg = 'Error loading sessions[' + target + '] info:'
          console.log msg, status, xhr
      )

module.exports = SessionsStore