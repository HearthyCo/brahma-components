AppDispatcher = require '../dispatcher/AppDispatcher'

SessionsActions = {

  refresh: (target) ->
    AppDispatcher.trigger 'sessions:refresh', {
      section: target
    }

}

module.exports = SessionsActions