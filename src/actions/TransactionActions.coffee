AppDispatcher = require '../dispatcher/AppDispatcher'
Backbone = require 'exoskeleton'

TransactionActions =

  refresh: ->
    AppDispatcher.trigger 'transaction:refresh', {}

  createPaypal: (amount) ->
    Backbone.ajax
      url: window.apiServer + '/transaction'
      contentType: "application/json; charset=utf-8"
      type: 'POST'
      dataType: 'jsonp'
      data: JSON.stringify amount: amount
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
        AppDispatcher.trigger 'transaction:executePaypalSuccess', result
      error: (xhr, status) ->
        AppDispatcher.trigger 'transaction:executePaypalError', {}

  errorExecutePaypal: ->
    AppDispatcher.trigger 'transaction:executePaypalError', {}

module.exports = TransactionActions