Config = require '../util/config'
AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'
Backbone = require 'exoskeleton'

TransactionActions =

  refresh: ->
    Utils.mkApiGetter '/me/transactions', 'transactions', 'UserTransactions'

  createPaypal: (amount, redirectUrls) ->
    data = {}
    data.amount = amount
    if redirectUrls?
      data.redirectUrls = redirectUrls

    Backbone.ajax
      url: Config.api.url + '/transaction'
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
      url: Config.api.url + '/transaction/execute'
      contentType: "application/json; charset=utf-8"
      type: 'POST'
      dataType: 'jsonp'
      data: JSON.stringify paypalParams
      success: (result) ->
        result.serviceId = paypalParams.serviceId
        AppDispatcher.trigger 'transaction:ExecutePaypal:success', result
      error: (xhr, status) ->
        AppDispatcher.trigger 'transaction:ExecutePaypal:error', {}

  errorExecutePaypal: ->
    AppDispatcher.trigger 'transaction:ExecutePaypal:error', {}

module.exports = TransactionActions