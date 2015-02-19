Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'


SessionItem = Backbone.Model.extend
  urlRoot: -> window.apiServer + '/session'
  parse: (o, opts) ->
    if opts.collection then return o # No double parse
    o.session

SessionCollection = Backbone.Collection.extend
  model: SessionItem
  parse: (o) ->
    o.sessions

SessionStore = new SessionCollection

SessionStore.addChangeListener = (callback) ->
  SessionStore.on 'change', callback

SessionStore.removeChangeListener = (callback) ->
  SessionStore.off 'change', callback

SessionStore._get = SessionStore.get
SessionStore.get = (key) ->
  r = @_get key
  if r
    r = r.toJSON()
  r
SessionStore.getAll = ->
  @map (o) -> o.toJSON()

AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'session:refresh'
      if not SessionStore.get payload.id
        SessionStore.add {id: payload.id}
      SessionStore._get(payload.id).fetch
        success: (session) ->
          msg = 'Downloaded session #' + payload.id + ':'
          console.log msg, session.toJSON()
          #SessionStore.trigger 'change'
        error: (xhr, status) ->
          msg = 'Error loading session #' + payload.id + ':'
          console.log msg, status, xhr


module.exports = SessionStore