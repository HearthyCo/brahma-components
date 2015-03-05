Utils = require '../util/storeUtils'
Socket = require '../util/socket'

module.exports =
  User: Utils.mkEntityStore 'users', (evt, payload) ->
    loginEvents = ['user:successLogin', 'user:successSignup']
    if loginEvents.indexOf(evt) >= 0
      @currentUid = payload.users[0].id
      @socket = Socket(payload.users[0])
    if evt is 'user:successMe'
      @currentUid = payload.users[0].id
    if evt is 'user:didLogout'
      @currentUid = null
  Transaction: Utils.mkEntityStore 'transactions'
  ServiceType: Utils.mkEntityStore 'servicetypes'
  Session: Utils.mkEntityStore 'sessions'
  SessionUser: Utils.mkEntityStore 'sessionusers'
  HistoryEntry: Utils.mkEntityStore 'historyentries'
  Message: Utils.mkEntityStore 'messages'