Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'

conf =
  endpoint: '/me/history'

HistoryItem = Backbone.Model.extend {}

HistoryCollection = Backbone.Collection.extend
  url: -> window.apiServer + conf.endpoint
  model: HistoryItem
  parse: (o) ->
    o.history


HistoryStore = new HistoryCollection()


HistoryStore.addChangeListener = (callback) ->
  HistoryStore.on 'change', callback

HistoryStore.removeChangeListener = (callback) ->
  HistoryStore.off 'change', callback

HistoryStore._get = HistoryStore.get
HistoryStore.get = (key) ->
  r = @_get key
  if r
    r = r.toJSON()
  r
HistoryStore.getAll = ->
  @map (o) -> o.toJSON()

HistoryStore.getSection = (section) ->
  @where(type: section).map (o) -> o.toJSON()


AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'history:refresh'
      HistoryStore.fetch
        url: window.apiServer + conf.endpoint + '/' + payload.section
        reset: true
        success: (entries) ->
          msg = 'Downloaded history entries:'
          console.log msg, entries.getSection payload.section
          HistoryStore.trigger 'change'
        error: (xhr, status) ->
          msg = 'Error loading history entries:'
          console.log msg, status, xhr


module.exports = HistoryStore