AppDispatcher = require '../dispatcher/AppDispatcher'

AlertActions =

  show: (id, content, level) ->
    AppDispatcher.trigger 'alert:Show',
      id: id
      content: content
      level: level or 'info'
      onDone: ->
        # setTimeout ->
        #   AppDispatcher.trigger 'alert:hide',
        #     id: id
        #   console.info "#{id} should be dead x_x"
        # , 2000

  hide: (id) ->
    AppDispatcher.trigger 'alert:Hide',
      id: id

  close: ->
    AppDispatcher.trigger 'alert:Close', {}

module.exports = AlertActions
