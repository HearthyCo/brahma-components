Backbone = require 'exoskeleton'
_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'

AlertStore =
  visible: false
  alerts: {}
  alertsIdx: []
  # item:
  #   id:      'something'
  #   content: false
  #   level:   'info'

_.extend AlertStore, Backbone.Events

AlertStore.addChangeListener = (callback) ->
  AlertStore.on  'change', callback

AlertStore.removeChangeListener = (callback) ->
  AlertStore.off 'change', callback

AlertStore.getAlert    = (id) -> AlertStore.alerts[id] or null
AlertStore.getAlertPos = (id) -> AlertStore.alertsIdx.indexOf(id)

AlertStore.getAlerts    = ->
  alerts:    AlertStore.alerts
  alertsIdx: AlertStore.alertsIdx
  visible:   AlertStore.visible

AlertStore.getFirstAlert = ->
  AlertStore.alerts[_.first(AlertStore.alertsIdx)] or null

AlertStore.getLastAlert = ->
  AlertStore.alerts[_.last(AlertStore.alertsIdx)] or null

# Alert index functions
_addIdx = (id) ->
  idx = AlertStore.alertsIdx
  pos = idx.indexOf id
  if pos >= 0
    idx.splice pos, 1
    # duplicity isn't checked
  return idx.push id

_removeIdx = (id) ->
  idx = AlertStore.alertsIdx
  pos = idx.indexOf id
  if pos >= 0
    idx.splice pos, 1
    # duplicity isn't checked
  return (pos >= 0)

# Alert management functions
_addAlert = (payload) ->
  if payload.id
    id = payload.id
    _addIdx payload.id
    AlertStore.alerts[id] = payload
    return id
  return false

_removeAlert = (id) ->
  delete AlertStore.alerts[id]
  return _removeIdx id

# Alerts visibility functions
_showAlerts = ->
  if not AlertStore.visible
    AlertStore.visible = true
    return true
  return false

_hideAlerts = ->
  if AlertStore.visible
    AlertStore.visible = false
    return true
  return false

_checkVisibility = ->
  if AlertStore.alertsIdx.length > 0
    _showAlerts()
  else
    _hideAlerts()

# Reset to intial state
_destroyAlerts = ->
  AlertStore.alertsIdx = []
  AlertStore.alerts = {}

AppDispatcher.on 'all', (eventName, payload) ->
  [ evtModel, evtAction, evtResult ] = eventName.split ':'

  # It's an alert call
  if evtModel is 'alert'
    switch evtAction
      when 'Show'
        if _addAlert payload
          _checkVisibility()
          AlertStore.trigger 'change'
        else
          console.warn "AlertStore show: unknown alert ID [#{payload.id}]"

      when 'Hide'
        if _removeAlert payload.id
          _checkVisibility()
          AlertStore.trigger 'change'
        else
          # something is trying to hide an unknown alert
          console.warn "AlertStore hide: unknown alert ID [#{payload.id}]"

      when 'Close'
        _destroyAlerts()
        _hideAlerts()
        AlertStore.trigger 'change'

  # It's an error
  else if evtResult is 'error'
    alertObj =
      id: "alert-#{evtModel}_#{evtAction}"
      content: "(#{evtModel}) #{evtAction} #{evtResult}"
      level: evtResult

    AppDispatcher.trigger 'alert:Show', alertObj

  # It's an error
  else if evtResult is 'success'
    alertObj = id: "alert-#{evtModel}_#{evtAction}"

    AppDispatcher.trigger 'alert:Hide', alertObj


module.exports = AlertStore
