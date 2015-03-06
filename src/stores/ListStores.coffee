_ = require 'underscore'
Utils = require '../util/storeUtils'
EntityStores = require './EntityStores'

ListToSublist = (messages) ->
  sessions = {}
  for message in messages
    sessions[message.session] = [] if not sessions[message.session]
    sessions[message.session].push message.id
  sessions

# TODO doc
ListToSublistAppender = (f) -> Utils.subListAppender (o) -> ListToSublist f o

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
      'chat:successReceived': ListToSublistAppender (o) -> o.messages
      'chat:requestSend': ListToSublistAppender (o) -> o.messages
      'chat:requestSendFile': ListToSublistAppender (o) -> o.messages

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
