Config = require '../util/config'
AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'
Backbone = require 'exoskeleton'

TransactionActions =

  refresh: ->
    Utils.mkApiGetter '/me/transactions', 'transactions', 'UserTransactions'

  # Creates a new Paypal payment, and redirects to the authorization URL
  createPaypal: (amount, redirectUrls) ->
    data = {}
    data.amount = amount
    data.redirectUrls = redirectUrls if redirectUrls?

    if process.env.HEARTHY_APP isnt 'web'
      AppDispatcher.trigger 'transaction:CreatePaypal:request', data
      return

    Utils.mkApiPoster '/transaction', data, 'transaction', 'CreatePaypal',
      success: (result) ->
        try
          url = result.redirect
          console.log 'Redirecting to paypal at:', url
          window.location.replace url
        catch ex
          console.error 'Can\'t redirect to paypal:', ex, result
      error: (xhr, status) ->
        console.error 'Can\t redirect to paypal:', status, xhr

  # Sends a just-authorized payment to be executed at the server
  executePaypal: (paypalParams) ->
    Utils.mkApiPoster '/transaction/execute', paypalParams,
      'transaction', 'ExecutePaypal'

  # Sends an authorization from the mobile sdk to be captured by the server
  capturePaypal: (id, amount) ->
    # We use the same event as executePaypal because they are always
    # handled the same way
    opts =
      authorizationId: id
      amount: amount
    Utils.mkApiPoster '/transaction/capture', opts,
      'transaction', 'ExecutePaypal'

  # Notifies of an error during Paypal operations
  errorExecutePaypal: ->
    AppDispatcher.trigger 'transaction:ExecutePaypal:error', {}

window.brahma.actions.transaction = module.exports = TransactionActions
