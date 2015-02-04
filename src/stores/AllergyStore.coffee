Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'


AllergyItem = Backbone.Model.extend {}

AllergyCollection = Backbone.Collection.extend
  url: window.apiServer + '/v1/user/history/allergies'
  model: AllergyItem
  parse: (o) ->
    o.history


AllergyStore = new AllergyCollection()


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
        reset: true
        success: (allergies) ->
          msg = 'Downloaded allergies:'
          console.log msg, allergies.getAll()
          AllergyStore.trigger 'change'
        error: (xhr, status) ->
          msg = 'Error loading allergies:'
          console.log msg, status, xhr


module.exports = AllergyStore