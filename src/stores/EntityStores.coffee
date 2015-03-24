Utils = require '../util/storeUtils'

# Stores for Entities

module.exports =
  User: Utils.mkEntityStore 'users', (evt, payload) ->
    loginEvents = ['user:successLogin', 'user:successSignup', 'user:successMe']
    if loginEvents.indexOf(evt) >= 0
      @currentUid = payload.users[0].id
    if evt is 'user:successLogout'
      @currentUid = null
      @trigger 'change'
  Transaction: Utils.mkEntityStore 'transactions'
  ServiceType: Utils.mkEntityStore 'servicetypes'
  Session: Utils.mkEntityStore 'sessions'
  SessionUser: Utils.mkEntityStore 'sessionusers'
  HistoryEntry: Utils.mkEntityStore 'historyentries'
  Message: Utils.mkEntityStore 'messages'
  SignedEntry: Utils.mkEntityStore 'sign'