AppDispatcher = require '../dispatcher/AppDispatcher'

TransactionActions =

  refresh: ->
    AppDispatcher.trigger 'transaction:refresh', {}


module.exports = TransactionActions