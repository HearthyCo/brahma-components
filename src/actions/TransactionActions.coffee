AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'
Backbone = require 'exoskeleton'

TransactionActions =

  refresh: ->
    Utils.mkApiGetter '/me/transactions', 'transactions:', 'UserTransactions'

  createPaypal: (amount, redirectUrls) ->
    data = {}
    data.amount = amount
    if redirectUrls?
      data.redirectUrls = redirectUrls

    Backbone.ajax
      url: window.apiServer + '/transaction'
      contentType: "application/json; charset=utf-8"
      type: 'POST'
      dataType: 'jsonp'
      data: JSON.stringify data
      success: (result) ->
        try
          url = result.redirect
          console.log 'Redirecting to paypal at:', url
          window.location.replace url
        catch e
          console.error 'Can\'t redirect to paypal:', e, result
      error: (xhr, status) ->
        console.error 'Can\t redirect to paypal:', status, xhr

  executePaypal: (paypalParams) ->
    Backbone.ajax
      url: window.apiServer + '/transaction/execute'
      contentType: "application/json; charset=utf-8"
      type: 'POST'
      dataType: 'jsonp'
      data: JSON.stringify paypalParams
      success: (result) ->
        result.serviceId = paypalParams.serviceId
        AppDispatcher.trigger 'transaction:executePaypalSuccess', result
      error: (xhr, status) ->
        AppDispatcher.trigger 'transaction:executePaypalError', {}

  errorExecutePaypal: ->
    AppDispatcher.trigger 'transaction:executePaypalError', {}

module.exports = TransactionActions