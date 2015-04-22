Utils = require '../util/actionsUtils'

HomeActions =

  refresh: ->
    Utils.mkApiGetter '/me/home', 'clientHome', 'Home'

module.exports = HomeActions