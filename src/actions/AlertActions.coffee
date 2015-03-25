AppDispatcher = require '../dispatcher/AppDispatcher'

AlertActions =

  show: (id, content, level) ->
    AppDispatcher.trigger 'alert:show',
      id: id
      content: content
      level: level or 'info'

  hide: (id) ->
    AppDispatcher.trigger 'alert:hide',
      id: id

  close: ->
    AppDispatcher.trigger 'alert:close', {}

module.exports = AlertActions