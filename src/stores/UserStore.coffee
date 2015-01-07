Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'

UserStore = Backbone.Model.extend({
  urlRoot: '/v1/user'
  defaults: {
    type: 'CLIENT'
  }
})

# Mandatory fields: login, password, gender, name, birthdate

#AppDispatcher.on 'all', (eventName, payload) ->
#  switch eventName
#    when 'create' then
#      create payload

module.exports = UserStore