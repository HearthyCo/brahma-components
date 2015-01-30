jest.dontMock '../HomeStore'
jest.dontMock '../SessionStore'
window.apiServer = ''

describe 'Home Store', ->

  it 'handles home:refresh event by GETting the home content', ->

    Backbone = require 'exoskeleton'
    Backbone.ajax = jest.genMockFunction()
    HomeStore = require '../HomeStore'
    AppDispatcher = require '../../dispatcher/AppDispatcher'
    handler = AppDispatcher.on.mock.calls[1][1] # 1st call is from SessionStore

    # Check that dispatcher event leads to ajax call
    handler 'home:refresh', {}

    data = Backbone.ajax.mock.calls[0][0]
    expect(data.type).toEqual undefined
    expect(data.url).toEqual '/v1/user/home'

    # Check that ajax response updates store and triggers change event
    answer =
      sessions:
        programmed: [
          id: 90700
          title: 'testSession1'
          startDate: 1425312000000
          endDate: 1425312900000
          state: 'PROGRAMMED'
          meta: {}
          timestamp: 1418626800000
          isNew: false
        ]
        underway: []
        closed: []

    changeHandler = jest.genMockFunction()
    HomeStore.addChangeListener changeHandler
    data.success answer, 'success'
    home = HomeStore.getAll()
    expect(home).toEqual answer
    expect(changeHandler.mock.calls.length).toEqual 1