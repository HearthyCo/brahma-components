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

  Session:
    Participants: Utils.mkSubListStore EntityStores.SessionUser,
      'session:successSession': (o) -> o.participants
    Messages: Utils.mkSubListStore EntityStores.Message,
      'chat:successReceived': MixNewMessages
      'chat:requestSend': MixNewMessages
      'chat:requestSendFile': MixNewMessages
      'chat:successSendFile': MixNewMessages
      'chat:errorSendFile': MixNewMessages

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

window.listStores = module.exports = Stores
