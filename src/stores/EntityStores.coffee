Utils = require '../util/storeUtils'

# Stores for Entities

window.brahma.stores.entity = module.exports =
  User: Utils.mkEntityStore 'users', (evt, payload) ->
    loginEvents = [
      'user:Login:success'
      'user:Signup:success'
      'user:Me:success'
    ]
    if loginEvents.indexOf(evt) >= 0
      @currentUid = payload.users[0].id
    if evt is 'user:Logout:success'
      @currentUid = null
      @trigger 'change'
  Transaction: Utils.mkEntityStore 'transactions'
  ServiceType: Utils.mkEntityStore 'servicetypes'
  Session: Utils.mkEntityStore 'sessions'
  SessionUser: Utils.mkEntityStore 'sessionusers'
  HistoryEntry: Utils.mkEntityStore 'historyentries'
  Message: Utils.mkEntityStore 'messages'
  SignedEntry: Utils.mkEntityStore 'sign'
  Misc: Utils.mkEntityStore 'misc'
