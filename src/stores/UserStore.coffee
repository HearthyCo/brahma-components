Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'

UserActions = require '../actions/UserActions'

# Mandatory fields: login, password, gender, name, birthdate
UserItem = Backbone.Model.extend
  urlRoot: '/v1/user'
  defaults:
    type: 'CLIENT'
  parse: (o) ->
    o.user


UserCollection = Backbone.Collection.extend
  model: UserItem


UserStore = new UserCollection

UserStore.addChangeListener = (callback) ->
  UserStore.on 'change', callback

UserStore.removeChangeListener = (callback) ->
  UserStore.off 'change', callback

UserStore._get = UserStore.get
UserStore.get = (key) ->
  r = @_get key
  if r
    r = r.toJSON()
  r
UserStore.getAll = ->
  @map (o) -> o.toJSON()


AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'user:register'
      UserStore.create payload.user, {
        success: (model, response) ->
          UserStore.currentUid = model.get('id')
          UserStore.trigger 'change'
          console.log 'Register success!', model.toJSON(), response
        error: (model, response) ->
          console.log 'Error registering!', model.toJSON(), response
      }

    when 'user:login'
      UserStore.create payload.user, {
        url: '/v1/user/login'
        success: (model, response) ->
          UserStore.currentUid = model.get('id')
          UserStore.trigger 'change'
          console.log 'Login success!', model.toJSON(), response
        error: (model, response) ->
          console.log 'Login error!', model.toJSON(), response
      }


module.exports = UserStore