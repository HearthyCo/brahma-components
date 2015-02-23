AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'

HistoryActions =

  refresh: (section) ->
    evtSuffix = section.charAt(0).toUpperCase() + section.slice(1) + 'Sessions'
    Utils.mkApiGetter '/me/history/' + section, 'history:', evtSuffix


module.exports = HistoryActions