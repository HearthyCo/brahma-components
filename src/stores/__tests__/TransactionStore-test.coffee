jest.dontMock '../TransactionStore'
window.apiServer = ''

describe 'Transaction Store', ->

  it 'handles transaction:refresh event by GETting the transaction list', ->

    Backbone = require 'exoskeleton'
    Backbone.ajax = jest.genMockFunction()
    TransactionStore = require '../TransactionStore'
    AppDispatcher = require '../../dispatcher/AppDispatcher'
    handler = AppDispatcher.on.mock.calls[0][1]

    # Check that dispatcher event leads to ajax call
    handler 'transaction:refresh', {}

    data = Backbone.ajax.mock.calls[0][0]
    expect(data.type).toEqual 'GET'
    expect(data.url).toEqual '/v1/user/balance'

    # Check that ajax response updates store and triggers change event
    answer =
      balance:
        amount: 20000000,
        transactions: [
          id: 91300
          amount: -1000
          timestamp: 1418626800000
          reason: "Reserva de sesión"
          title: "testSession1"
        ]

    changeHandler = jest.genMockFunction()
    TransactionStore.addChangeListener changeHandler
    data.success answer, 'success'
    transactions = TransactionStore.getAll()
    expect(transactions).toEqual answer.balance.transactions
    expect(changeHandler.mock.calls.length).toEqual 1