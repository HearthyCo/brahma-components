Backbone = require 'exoskeleton'
_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'

AlertStore =
  visible: false
  alerts: []
  # item:
  #   content: false
  #   level:   'info'

_.extend AlertStore, Backbone.Events

AlertStore.addChangeListener = (callback) ->
  AlertStore.on  'change', callback

AlertStore.removeChangeListener = (callback) ->
  AlertStore.off 'change', callback

AlertStore.getAlert = (n) -> AlertStore.alerts[n or 0] or null

AlertStore.getAlerts = -> AlertStore.alerts

AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'alert:show'
      if payload.content
        AlertStore.visible = true
        AlertStore.alerts.push payload
        AlertStore.trigger 'change'
    when 'alert:hide'
      AlertStore.alerts.shift()
      if AlertStore.alerts.length is 0
        AlertStore.visible = false
      AlertStore.trigger 'change'
    when 'alert:close'
      AlertStore.alerts = []
      AlertStore.visible = false
      AlertStore.trigger 'change'

module.exports = AlertStore
