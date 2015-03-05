AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'
Queue = require '../util/queue'

success = ->
  success: (response) ->
    @defaultOpts.success response
    Queue.initSocket response.users[0]

UserActions =

  login: (user) ->
    Utils.mkApiPoster '/login', user, 'user:', 'Login', success()

  logout: ->
    Utils.mkApiPoster '/logout', {}, 'user:', 'Logout'

  register: (user) ->
    user.login = user.login || user.email
    Utils.mkApiPoster '', user, 'user:', 'Signup', success()

  getMe: ->
    Utils.mkApiGetter '/me', 'user:', 'Me', success()

  save: (user) ->
    Utils.mkApiPoster '/me/update', user, 'user:', 'Save'


module.exports = UserActions