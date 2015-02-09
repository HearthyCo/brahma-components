Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'

UserActions = require '../actions/UserActions'

LOG = 'UserStore > '

# Mandatory fields: login, password, gender, name, birthdate
UserItem = Backbone.Model.extend
  urlRoot: -> window.apiServer + '/v1/user'
  defaults:
    type: 'CLIENT'
  parse: (o, opts) ->
    if opts.collection then return o # No double parse
    o.user


UserCollection = Backbone.Collection.extend
  model: UserItem
  url: -> window.apiServer + '/v1/user'
  parse: (o) ->
    o.user

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
          console.log LOG + 'Register success', model.toJSON(), response
          UserStore.currentUid = model.get('id')
          UserStore.trigger 'change'
        error: (model, response) ->
          console.error LOG + 'Register error', model.toJSON(), response
      }

    when 'user:login'
      UserStore.create payload.user, {
        url: window.apiServer + '/v1/user/login'
        success: (model, response) ->
          console.log LOG + 'Login success', model.toJSON(), response
          UserStore.currentUid = model.get('id')
          UserStore.trigger 'change'
        error: (model, response) ->
          console.error LOG + 'Login error', model.toJSON(), response
      }

    when 'user:logout'
      Backbone.ajax
        url: window.apiServer + '/v1/user/logout'
        type: 'POST',
        success: (response) ->
          console.log 'Logout success', response
          UserStore.currentUid = null
          UserStore.trigger 'change'
        error: (xhr, status) ->
          console.error LOG + 'Logout error', status, xhr

    when 'user:getMe'
      UserStore.fetch
        success: (models, response) ->
          console.log LOG + 'User info success', models.toJSON(), response
          UserStore.currentUid = response.user[0].id
          UserStore.trigger 'change'
        error: (models, response) ->
          console.error LOG + 'User info error', models.toJSON(), response

    when 'transaction:executePaypalSuccess'
      UserStore._get(UserStore.currentUid).set 'balance', payload.balance

module.exports = UserStore