Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'

UserStore = Backbone.Model.extend({
  urlRoot: '/v1/user'
  defaults: {
    type: 'CLIENT'
  }
})

# Mandatory fields: login, password, gender, name, birthdate

AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'user:register'
      user = new UserStore()
      user.save payload.user, {
        success: (model, response) ->
          console.log 'Register success!', model, response
        error: (model, response) ->
          console.log 'Error registering!', model, response
      }


module.exports = UserStore