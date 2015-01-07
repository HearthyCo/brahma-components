AppDispatcher = require '../dispatcher/AppDispatcher'

UserActions = {

  login: (user) ->
    AppDispatcher.trigger 'user:login', {
      user: user
    }

  register: (user) ->
    AppDispatcher.trigger 'user:register', {
      user: user
    }

}

module.exports = UserActions