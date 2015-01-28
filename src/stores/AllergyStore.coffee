Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'


AllergyItem = Backbone.Model.extend {}

AllergyCollection = Backbone.Collection.extend
  url: window.apiServer + '/v1/user/allergies'
  model: AllergyItem
  parse: (o) ->
    o.allergies


# DEBUG: Remove sample data
AllergyStore = new AllergyCollection [
  {id: 1, title: 'Polen', description: 'lorem', meta: rating: 5}
  {id: 2, title: 'Gramíneas', description: 'ipsum', meta: rating: 3}
  {id: 3, title: 'Ácaros', description: 'dolor', meta: rating: 2}
  {id: 4, title: 'Plátano', description: 'sit', meta: rating: 3}
  {id: 5, title: 'Anisakis', description: 'amet', meta: rating: 5}
  {id: 6, title: 'Trigo', description: 'consectetur', meta: rating: 3}
]


AllergyStore.addChangeListener = (callback) ->
  AllergyStore.on 'change', callback

AllergyStore.removeChangeListener = (callback) ->
  AllergyStore.off 'change', callback

AllergyStore._get = AllergyStore.get
AllergyStore.get = (key) ->
  r = @_get key
  if r
    r = r.toJSON()
  r
AllergyStore.getAll = ->
  @map (o) -> o.toJSON()


AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'allergy:refresh'
      AllergyStore.fetch
        success: (allergies) ->
          msg = 'Downloaded allergies:'
          console.log msg, allergies.getAll()
          AllergyStore.trigger 'change'
        error: (xhr, status) ->
          msg = 'Error loading allergies:'
          console.log msg, status, xhr


module.exports = AllergyStore