Utils = require '../util/storeUtils'
EntityStores = require './EntityStores'

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
      'history:successAllergies': (o) -> o.allergies

  Session:
    Participants: Utils.mkSubListStore EntityStores.SessionUser,
      'session:successSession': (o) -> o.participants
    Messages: Utils.mkSubListStore EntityStores.Message,
      'chat:successSend': (o, l) ->
        nl = o.messages
        if l[o.session]
          nl = l[o.session].concat o.messages
        ret = {}
        ret[o.session] = nl
        return ret

  ServiceTypes: Utils.mkListStore EntityStores.ServiceType,
    'serviceTypes:successServiceTypes': (o) ->
      # (H)
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
