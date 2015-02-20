Utils = require '../util/storeUtils'
EntityStores = require './EntityStores'

Stores =

  SessionsByState:
    Programmed: Utils.mkListStore EntityStores.Session,
      'sessions:gotSessionsByState': (o) -> o.programmedSessions
    Underway: Utils.mkListStore EntityStores.Session,
      'sessions:gotSessionsByState': (o) -> o.underwaySessions
    Closed: Utils.mkListStore EntityStores.Session,
      'sessions:gotSessionsByState': (o) -> o.closedSessions

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
    'transactions:gotUserTransactions': (o) -> o.transactions

Stores.Home.getAll = ->
  sessions:
    programmed: Stores.Home.Sessions.Programmed.getObjects()
    underway: Stores.Home.Sessions.Underway.getObjects()
    closed: Stores.Home.Sessions.Closed.getObjects()
  transactions: Stores.Home.Transactions.getObjects()

Stores.Home.addChangeListener = (cb) ->
  Stores.Home.Sessions.Programmed.addChangeListener cb
  Stores.Home.Sessions.Underway.addChangeListener cb
  Stores.Home.Sessions.Closed.addChangeListener cb
  Stores.Home.Transactions.addChangeListener cb

Stores.Home.removeChangeListener = (cb) ->
  Stores.Home.Sessions.Programmed.removeChangeListener cb
  Stores.Home.Sessions.Underway.removeChangeListener cb
  Stores.Home.Sessions.Closed.removeChangeListener cb
  Stores.Home.Transactions.removeChangeListener cb

module.exports = Stores