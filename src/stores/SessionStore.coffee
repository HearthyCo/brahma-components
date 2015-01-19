Backbone = require 'exoskeleton'
AppDispatcher = require '../dispatcher/AppDispatcher'

SessionStore = Backbone.Model.extend({
  urlRoot: '/v1/session'
})


AppDispatcher.on 'all', (eventName, payload) ->
  switch eventName
    when 'session:refresh'
      1 # TODO


module.exports = SessionStore