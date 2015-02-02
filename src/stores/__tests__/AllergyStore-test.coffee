jest.dontMock '../AllergyStore'
window.apiServer = ''

describe 'Allergy Store', ->

  it 'handles allergy:refresh event by GETting the user allergies', ->

    Backbone = require 'exoskeleton'
    Backbone.ajax = jest.genMockFunction()
    AllergyStore = require '../AllergyStore'
    AppDispatcher = require '../../dispatcher/AppDispatcher'
    handler = AppDispatcher.on.mock.calls[0][1]

    # Check that dispatcher event leads to ajax call
    handler 'allergy:refresh', {}

    data = Backbone.ajax.mock.calls[0][0]
    expect(data.type).toEqual 'GET'
    expect(data.url).toEqual '/v1/user/allergies'

    # Check that ajax response updates store and triggers change event
    answer =
      allergies: [
        {id: 1, title: 'Polen', description: 'lorem', meta: rating: 5}
        {id: 2, title: 'Gramíneas', description: 'ipsum', meta: rating: 3}
      ]

    changeHandler = jest.genMockFunction()
    AllergyStore.addChangeListener changeHandler
    data.success answer, 'success'
    allergies = AllergyStore.getAll()
    expect(allergies).toEqual answer.allergies
    expect(changeHandler.mock.calls.length).toEqual 1
