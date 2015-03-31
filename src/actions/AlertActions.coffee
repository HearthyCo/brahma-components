AppDispatcher = require '../dispatcher/AppDispatcher'

AlertActions =

  show: (id, content, level) ->
    AppDispatcher.trigger 'alert:Show',
      id: id
      content: content
      level: level or 'info'
      onDone: ->
        setTimeout ->
          AppDispatcher.trigger 'alert:Hide', id: id
          console.info "#{id} should be dead x_x"
        , 4000

  hide: (id) ->
    AppDispatcher.trigger 'alert:Hide',
      id: id

  close: ->
    AppDispatcher.trigger 'alert:Close', {}

  formAlert: (payload) ->
    AppDispatcher.trigger 'alert:FormAlert', payload

module.exports = AlertActions
