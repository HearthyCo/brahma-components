Utils = require '../util/actionsUtils'

SessionsActions =

  refresh: () ->
    Utils.mkApiGetter '/me/sessions', # DEBUG remove...
      'sessions:', 'Sessions'

module.exports = SessionsActions