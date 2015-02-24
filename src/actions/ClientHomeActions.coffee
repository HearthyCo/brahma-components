AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'

HomeActions =

  refresh: (user) ->
    Utils.mkApiGetter '/me/home', 'clientHome:', 'Home'


module.exports = HomeActions