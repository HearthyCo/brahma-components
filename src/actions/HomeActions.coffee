AppDispatcher = require '../dispatcher/AppDispatcher'

HomeActions = {

  refresh: (user) ->
    AppDispatcher.trigger 'home:refresh', {
      user: user
    }

}

module.exports = HomeActions