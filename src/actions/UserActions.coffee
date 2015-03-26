AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'
Queue = require '../util/queue'
FrontendUtils = require '../util/frontendUtils'

AlertActions = require './AlertActions'

response = (actionId) ->
  success: (resp) ->
    if actionId in ['UserLogin', 'UserRegister', 'UserGetMe']
      Queue.initSocket resp.users[0]
    AlertActions.show "alert-#{actionId}", "Success: #{actionId}", 'success'

  error: (resp) ->
    AlertActions.show "alert-#{actionId}", "Error: #{actionId}", 'error'

UserActions =

  login: (user) ->
    Utils.mkApiPoster '/login', user, 'user:', 'Login', response 'UserLogin'

  logout: ->
    Utils.mkApiPoster '/logout', {}, 'user:', 'Logout', response 'UserLogout'

  register: (user) ->
    user.login = user.login || user.email
    Utils.mkApiPoster '', user, 'user:', 'Signup', response 'UserRegister'

  getMe: ->
    Utils.mkApiGetter '/me', 'user:', 'Me', response 'UserGetMe'

  save: (user) ->
    Utils.mkApiPoster '/me/update', user, 'user:', 'Save', response 'UserSave'

  confirmMail: (uid, hash) ->
    pl = userId: uid, hash: hash
    Utils.mkApiPoster '/me/confirm', pl, 'user:', 'ConfirmMail'

  requestPasswordChange: (email) ->
    pl = email: email
    Utils.mkApiPoster '/recover', pl, 'user:', 'RequestPasswordChange'

  confirmPasswordChange: (uid, hash, password) ->
    pl = userId: uid, hash: hash, newPassword: password
    Utils.mkApiPoster '/recover/confirm', pl, 'user:', 'ConfirmPasswordChange'

  setAvatar: (file) ->
    FrontendUtils.imageScaleCropBlob file, 150, 150, (blob) ->
      pl = avatar: file
      fd = new FormData()
      fd.append 'upload', blob, file.name
      opts = data: fd, contentType: false
      Utils.mkApiPoster '/me/avatar', pl, 'user:', 'SetAvatar', opts

module.exports = UserActions
