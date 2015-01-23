jest.dontMock '../SessionStore'

describe 'Session Store', ->

  it 'handles session:refresh event by GETting the specified session', ->

    Backbone = require 'exoskeleton'
    Backbone.ajax = jest.genMockFunction()
    SessionStore = require '../SessionStore'
    AppDispatcher = require '../../dispatcher/AppDispatcher'
    handler = AppDispatcher.on.mock.calls[0][1]

    # Check that dispatcher event leads to ajax call
    payload =
      id: 90700
    handler 'session:refresh', payload

    data = Backbone.ajax.mock.calls[0][0]
    expect(data.type).toEqual 'GET'
    expect(data.url).toEqual '/v1/session/90700'

    # Check that ajax response updates store and triggers change event
    answer =
      session:
        id: 90700
        title: 'testSession1'
        startDate: 1425312000000
        endDate: 1425312900000
        state: 'PROGRAMMED'
        meta: {}
        timestamp: 1418626800000
        users:
          me:
            id: 90000
          professionals: [
            id: 90005
          ]

    changeHandler = jest.genMockFunction()
    SessionStore.addChangeListener changeHandler
    data.success answer, 'success'
    session = SessionStore.get 90700
    expect(session).toEqual answer.session
    expect(changeHandler.mock.calls.length).toEqual 1