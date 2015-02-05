AppDispatcher = require '../dispatcher/AppDispatcher'

AllergyActions =

  refresh: ->
    AppDispatcher.trigger 'allergy:refresh', {}


module.exports = AllergyActions