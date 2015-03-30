Utils = require '../util/actionsUtils'

HistoryActions =

  refresh: (section) ->
    evtSuffix = section.charAt(0).toUpperCase() + section.slice(1)
    Utils.mkApiGetter '/me/history/' + section, 'history:', evtSuffix

module.exports = HistoryActions