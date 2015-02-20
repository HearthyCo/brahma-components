AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'

SessionsActions =

  refresh: (target) ->
    evtSuffix = target.charAt(0).toUpperCase() + target.slice(1) + 'Sessions'
    Utils.mkApiGetter '/me/sessions/' + target, 'sessions:', evtSuffix



module.exports = SessionsActions