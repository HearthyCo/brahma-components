AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'

HomeActions =

  refresh: (user) ->
    Utils.mkApiGetter '/me/home', 'home:', 'Home'


module.exports = HomeActions