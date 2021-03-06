Utils = require '../util/actionsUtils'
Queue = require '../util/queue'
FrontendUtils = require '../util/frontendUtils'

AlertActions = require './AlertActions'

response = (actionId) ->
  success: (resp) ->
    if actionId in ['UserLogin', 'UserRegister']
      Queue.initSocket resp.users[0]

    if actionId is 'UserLogout'
      Queue.close()

    AlertActions.formAlert {
      id: actionId
      content: "success-on-#{actionId.toLowerCase()}-form"
      level: "success"
    }

  error: -> #(resp) ->
    AlertActions.formAlert {
      id: actionId
      fields: ['email', 'password']
      content: "error-on-#{actionId.toLowerCase()}-form"
      level: "error"
    }

UserActions =

  login: (user) ->
    Utils.mkApiPoster '/login', user, 'user',
      'Login', response 'UserLogin'

  logout: ->
    Utils.mkApiPoster '/logout', {}, 'user',
      'Logout', response 'UserLogout'

  register: (user) ->
    user.login = user.login or user.email
    Utils.mkApiPoster '', user, 'user',
      'Signup', response 'UserRegister'

  getMe: ->
    Utils.mkApiGetter '/me', 'user',
      'Me', {
        errorLevel: 'warn'
        success: (resp) -> Queue.initSocket resp.users[0]
      }

  save: (user) ->
    Utils.mkApiPoster '/me/update', user, 'user',
      'Save', response 'UserSave'

  confirmMail: (uid, hash) ->
    pl = userId: uid, hash: hash
    Utils.mkApiPoster '/me/confirm', pl, 'user',
      'ConfirmMail', response 'UserConfirmEmail'

  requestPasswordChange: (email) ->
    pl = email: email
    Utils.mkApiPoster '/recover', pl, 'user',
      'RequestPasswordChange', response 'UserRequestPasswordChange'

  confirmPasswordChange: (uid, hash, password) ->
    pl = userId: uid, hash: hash, newPassword: password
    Utils.mkApiPoster '/recover/confirm', pl, 'user',
      'ConfirmPasswordChange', response 'UserConfirmPasswordChange'

  setAvatar: (file) ->
    FrontendUtils.imageScaleCropBlob file, 150, 150, (blob) ->
      pl = avatar: file
      fd = new window.FormData()
      fd.append 'upload', blob, file.name
      opts = data: fd, contentType: false
      Utils.mkApiPoster '/me/avatar', pl, 'user',
        'SetAvatar', opts

  updatePushNotifications: (token, service, lang) ->
    payload =
      token: token
      proto: service
      lang: lang
    Utils.mkApiPoster '/me/push', payload, 'user', 'updatePushNotifications'

window.brahma.actions.user = module.exports = UserActions
