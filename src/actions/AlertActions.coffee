_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'

AlertActions =

  ###
    Triggers the event to show an alert
  ###
  show: (payload) ->
    defaults =
      id: 'alert-undefined'
      content: 'Undetermined error'
      level: 'info'
      autoHide: 4000
      timer: null
      onDone: ->
        window.clearTimeout @timer if @timer
        if @autoHide
          @timer = window.setTimeout (=> AlertActions.hide @id),
            parseInt @autoHide

    _.defaults payload, defaults

    # bind
    payload.onDone = payload.onDone.bind payload

    AppDispatcher.trigger 'alert:Show', payload

  ###
    Triggers the event to hide an alert
  ###
  hide: (id) ->
    # string or object
    id = id if _.isObject id
    AppDispatcher.trigger 'alert:Hide', id: id

  ###
    Triggers the event to hide every alert
  ###
  close: ->
    AppDispatcher.trigger 'alert:Close', {}

  ###
    Alerts for forms. Commonly they'll be error or success.
  ###
  formAlert: (payload) ->
    AppDispatcher.trigger 'alert:FormAlert', payload

module.exports = AlertActions
