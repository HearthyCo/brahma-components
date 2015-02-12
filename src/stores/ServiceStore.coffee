Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'

conf =
  endpoint: '/v1/services'

ServiceItem = Backbone.Model.extend {}

ServiceCollection = Backbone.Collection.extend
  url: -> window.apiServer + conf.endpoint
  model: ServiceItem
  parse: (o) ->
    o.services

ServiceStore = new ServiceCollection

ServiceStore.addChangeListener = (callback) ->
  ServiceStore.on 'change', callback

ServiceStore.removeChangeListener = (callback) ->
  ServiceStore.off 'change', callback

ServiceStore._get = ServiceStore.get
ServiceStore.get = (key) ->
  r = @_get key
  if r
    r = r.toJSON()
  r
ServiceStore.getAll = ->
  @map (o) -> o.toJSON()

AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'service:refresh'
      ServiceStore.fetch
        url: window.apiServer + conf.endpoint + '?id=' + payload.id
        reset: true
        success: (services) ->
          msg = 'Updated services list:'
          console.log msg, services.getAll()
          ServiceStore.trigger 'change'
        error: (xhr, status) ->
          msg = 'Error updating services:'
          console.log msg, status, xhr

module.exports = ServiceStore