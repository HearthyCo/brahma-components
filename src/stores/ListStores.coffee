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

  Home:
    Sessions:
      Programmed: Utils.mkListStore EntityStores.Session,
        'home:successHome': (o) -> o.home.sessions.programmed
      Underway: Utils.mkListStore EntityStores.Session,
        'home:successHome': (o) -> o.home.sessions.underway
      Closed: Utils.mkListStore EntityStores.Session,
        'home:successHome': (o) -> o.home.sessions.closed
    Transactions: Utils.mkListStore EntityStores.Transaction,
      'home:successHome': (o) -> o.home.transactions

  Transactions: Utils.mkListStore EntityStores.Transaction,
    'transactions:successUserTransactions': (o) -> o.userTransactions

  History:
    Allergies: Utils.mkListStore EntityStores.HistoryEntry,
      'history:successAllergies': (o) -> o.allergies

  Session:
    Participants: Utils.mkSubListStore EntityStores.SessionUser,
      'session:successSession': (o) -> o.participants

Stores.Home.getAll = -> Utils.treeEval Stores.Home, 'getObjects', []

Stores.Home.addChangeListener = (cb) ->
  Utils.treeEval Stores.Home, 'addChangeListener', [cb]

Stores.Home.removeChangeListener = (cb) ->
  Utils.treeEval Stores.Home, 'removeChangeListener', [cb]

window.listStores = module.exports = Stores
