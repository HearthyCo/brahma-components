Backbone = require 'exoskeleton'
_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'

Session = require './SessionStore'

conf =
  endpoint: '/v1/user/sessions'

Sessions = Backbone.Collection.extend
  model: Session
  url: -> endpoint + '/' + @kind
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
      1 # TODO

module.exports = SessionsStore