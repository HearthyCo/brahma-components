Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'


TransactionItem = Backbone.Model.extend {}

TransactionCollection = Backbone.Collection.extend
  url: -> window.apiServer + '/v1/user/balance'
  model: TransactionItem
  parse: (o) ->
    o.balance.transactions


TransactionStore = new TransactionCollection

TransactionStore.addChangeListener = (callback) ->
  TransactionStore.on 'change', callback

TransactionStore.removeChangeListener = (callback) ->
  TransactionStore.off 'change', callback

TransactionStore._get = TransactionStore.get
TransactionStore.get = (key) ->
  r = @_get key
  if r
    r = r.toJSON()
  r
TransactionStore.getAll = ->
  @map (o) -> o.toJSON()


AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'transaction:refresh'
      TransactionStore.fetch
        reset: true
        success: (transactions) ->
          msg = 'Updated transactions list:'
          console.log msg, transactions.getAll()
          TransactionStore.trigger 'change'
        error: (xhr, status) ->
          msg = 'Error updating transactions:'
          console.log msg, status, xhr


module.exports = TransactionStore