AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'

ServiceActions =
  refresh: ->
    Utils.mkApiGetter '/services', 'serviceTypes', 'ServiceTypes'

module.exports = ServiceActions