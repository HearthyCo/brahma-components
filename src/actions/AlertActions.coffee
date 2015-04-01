_ = require 'underscore'
AppDispatcher = require '../dispatcher/AppDispatcher'

AlertActions =

  show: (payload) ->
    defaults =
      id: 'alert-undefined'
      content: 'Undetermined error'
      level: 'info'
      autoHide: 4000
      onDone: ->
        if @autoHide
          setTimeout (=> AlertActions.hide @id), parseInt @autoHide

    _.defaults payload, defaults

    # bind
    payload.onDone = payload.onDone.bind payload

    AppDispatcher.trigger 'alert:Show', payload


  hide: (id) ->
    # string or object
    id = payload.id if _.isObject id
    AppDispatcher.trigger 'alert:Hide', id: id

  close: ->
    AppDispatcher.trigger 'alert:Close', {}

  formAlert: (payload) ->
    AppDispatcher.trigger 'alert:FormAlert', payload

module.exports = AlertActions
