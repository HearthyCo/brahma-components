AppDispatcher = require '../dispatcher/AppDispatcher'

ServiceActions =

  refresh: (target) ->
    AppDispatcher.trigger 'service:refresh',
      id: target

module.exports = ServiceActions