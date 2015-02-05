AppDispatcher = require '../dispatcher/AppDispatcher'

UserActions =

  login: (user) ->
    AppDispatcher.trigger 'user:login',
      user: user

  logout: ->
    AppDispatcher.trigger 'user:logout'

  register: (user) ->
    AppDispatcher.trigger 'user:register',
      user: user

  getMe: ->
    AppDispatcher.trigger 'user:getMe'


module.exports = UserActions