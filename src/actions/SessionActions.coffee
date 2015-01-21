AppDispatcher = require '../dispatcher/AppDispatcher'

SessionsActions = {

  refresh: (target) ->
    AppDispatcher.trigger 'session:refresh', {
      id: target
    }

}

module.exports = SessionsActions