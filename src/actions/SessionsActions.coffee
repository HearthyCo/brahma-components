AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'

SessionsActions =

  refresh: () ->
    Utils.mkApiGetter '/me/sessions/' + 'closed', # DEBUG remove...
      'sessions:', 'Sessions'



module.exports = SessionsActions