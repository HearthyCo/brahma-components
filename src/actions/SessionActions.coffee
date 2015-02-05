AppDispatcher = require '../dispatcher/AppDispatcher'

SessionActions =

  refresh: (target) ->
    AppDispatcher.trigger 'session:refresh',
      id: target


module.exports = SessionActions