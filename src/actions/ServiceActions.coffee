AppDispatcher = require '../dispatcher/AppDispatcher'

fieldId = 90200

ServiceActions =
  refresh: ->
    AppDispatcher.trigger 'service:refresh',
      id: fieldId

module.exports = ServiceActions