AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'

UserActions =

  login: (user) ->
    Utils.mkApiPoster '/login', user, 'user:', 'Login'

  logout: ->
    Utils.mkApiPoster '/logout', {}, 'user:', 'Logout'

  register: (user) ->
    user.login = user.login || user.email
    Utils.mkApiPoster '', user, 'user:', 'Signup'

  getMe: ->
    Utils.mkApiGetter '/me', 'user:', 'Me'

  save: (user) ->
    Utils.mkApiPoster '/me/update', user, 'user:', 'Save'


module.exports = UserActions