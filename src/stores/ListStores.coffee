_ = require 'underscore'
Utils = require '../util/storeUtils'
EntityStores = require './EntityStores'

MixNewMessages = (data, current) ->
  messages = data.messages
  sessions = {}
  # Add new ones
  for message in messages
    session = message.session
    sessions[session] = true
    current[session] = [] if not current[session]
    pos = current[session].indexOf message.id
    if pos is -1
      current[message.session].push message.id
  # Sort them by timestamp
  for session of sessions
    current[session].sort (a,b) ->
      ta = EntityStores.Message.get(a)?.timestamp
      tb = EntityStores.Message.get(b)?.timestamp
      ta - tb
  current

Stores =
  SessionsByState:
    Programmed: Utils.mkListStore EntityStores.Session,
      'sessions:successProgrammedSessions': (o) -> o.userSessions
    Underway: Utils.mkListStore EntityStores.Session,
      'sessions:successUnderwaySessions': (o) -> o.userSessions
    Closed: Utils.mkListStore EntityStores.Session,
      'sessions:successClosedSessions': (o) -> o.userSessions

  ClientHome:
    Sessions:
      Programmed: Utils.mkListStore EntityStores.Session,
        'clientHome:successHome': (o) -> o.home.sessions.programmed
      Underway: Utils.mkListStore EntityStores.Session,
        'clientHome:successHome': (o) -> o.home.sessions.underway
      Closed: Utils.mkListStore EntityStores.Session,
        'clientHome:successHome': (o) -> o.home.sessions.closed
    Transactions: Utils.mkListStore EntityStores.Transaction,
      'clientHome:successHome': (o) -> o.home.transactions

  Transactions: Utils.mkListStore EntityStores.Transaction,
    'transactions:successUserTransactions': (o) -> o.userTransactions

  History:
    Allergies: Utils.mkListStore EntityStores.HistoryEntry,
      'history:successAllergies': (o) -> o.allergies # Client-only, needs review

  User:
    History: Utils.mkSubListStore EntityStores.HistoryEntry,
      'session:successSession': (o) -> o.userHistoryEntries
    Sessions: Utils.mkListStore EntityStores.Session,
      'sessions:successSessions': (o) -> o.userSessions

  UserSignatures: Utils.mkListStore EntityStores.SignedEntry,
    'user:successLogin': (o) -> o.sign.map (i) -> i.id
    'user:successSignup': (o) -> o.sign.map (i) -> i.id
    'user:successMe': (o) -> o.sign.map (i) -> i.id
    'session:successAssign': (o) -> o.sign.map (i) -> i.id
    'session:successCreated': (o) -> o.sign.map (i) -> i.id
    'session:successBooked': (o) -> o.sign.map (i) -> i.id

  Session:
    Participants: Utils.mkSubListStore EntityStores.SessionUser,
      'session:successSession': (o) -> o.participants
    Messages: Utils.mkSubListStore EntityStores.Message,
      'chat:successReceived': MixNewMessages
      'chat:successHistoryReceived': MixNewMessages
      'chat:requestSend': MixNewMessages
      'chat:requestSendFile': MixNewMessages
      'chat:successSendFile': MixNewMessages
      'chat:errorSendFile': MixNewMessages
    LastViewedMessage: Utils.mkSubListStore EntityStores.Message, {
      'page:change': (o, l) ->
        if o.page.displayName is 'roomPage' or o.page.displayName is 'sessionChatPage'
          @currentSid = o.opts.sessionId
          messages = Stores.Session.Messages.getIds(o.opts.sessionId) || []
          l[o.opts.sessionId] = [messages[messages.length - 1]] if messages.length
        else
          # prevent invalid currentId when page is not a chat page
          @currentSid = 0
        l
      'chat:successReceived': (o, l) ->
        messageSession = o.messages[0].session + ''
        if @currentSid is messageSession
          messages = Stores.Session.Messages.getIds(messageSession) || []
          l[messageSession] = [messages[messages.length - 1]] if messages.length
        l
      'chat:requestSend': (o, l) ->
        messageSession = o.messages[0].session + ''
        if @currentSid is messageSession
          messages = Stores.Session.Messages.getIds(messageSession) || []
          l[messageSession] = [messages[messages.length - 1]] if messages.length
        l
      }, storageKey: 'LastViewedMessage'

  ServiceTypes: Utils.mkListStore EntityStores.ServiceType,
    'serviceTypes:successServiceTypes': (o) ->
      o.allServiceTypes || o.servicetypes.map (st) -> st.id

  SessionsByServiceType: Utils.mkSubListStore EntityStores.Session,
    'serviceTypes:successServiceTypes': (o) -> o.serviceTypeSessions
    'session:successAssign': (o) -> o.serviceTypeSessions

### Client ###
# Home
Stores.ClientHome.getAll = -> Utils.treeEval Stores.ClientHome, 'getObjects', []

Stores.ClientHome.addChangeListener = (cb) ->
  Utils.treeEval Stores.ClientHome, 'addChangeListener', [cb]

Stores.ClientHome.removeChangeListener = (cb) ->
  Utils.treeEval Stores.ClientHome, 'removeChangeListener', [cb]

### Common ###
# Messages
Stores.Session.LastViewedMessage.getCounter = (sessionId) ->
  messages = Stores.Session.Messages.getIds(sessionId) || []
  lastViewed = Stores.Session.LastViewedMessage.getIds sessionId

  return 0 if not messages?
  return messages.length if not lastViewed?

  messages.length - messages.indexOf(lastViewed[0]) - 1

window.listStores = module.exports = Stores
