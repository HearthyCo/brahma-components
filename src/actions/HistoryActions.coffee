AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'

HistoryActions =

  refresh: (section) ->
    evtAction = section.charAt(0).toUpperCase() + section.slice(1)
    Utils.mkApiGetter '/me/history/' + section, 'history', evtAction


module.exports = HistoryActions