AppDispatcher = require '../dispatcher/AppDispatcher'

AlertActions =

  show: (content, level) ->
    AppDispatcher.trigger 'alert:show',
      content: content
      level: level or 'info'

  hide: ->
    AppDispatcher.trigger 'alert:hide', {}

  close: ->
    AppDispatcher.trigger 'alert:close', {}

module.exports = AlertActions