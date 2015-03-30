AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'
Backbone = require 'exoskeleton'
PageActions = require './PageActions'
Queue = require '../util/queue'

SessionActions =

  create: (service) ->
    Utils.mkApiPoster '/session/create', service: service,
      'session', 'Created', success: (response) ->
        console.log 'API POST Success:', response
        AppDispatcher.trigger  'session:Created:success', response
        PageActions.navigate '/session/' + response.session.id
        Queue.socket.updateSessions() if Queue.socket

  # TODO: check if it works
  book: (service, startDate) ->
    Utils.mkApiPoster '/session/book',
      { service: service, startDate: startDate }, 'session', 'Booked',
      success: (response) ->
        console.log 'API POST Success:', response
        AppDispatcher.trigger  'session:Booked:success', response
        PageActions.navigate '/session/' + response.session.id
        Queue.socket.updateSessions() if Queue.socket

  assign: (serviceType) ->
    Utils.mkApiPoster '/session/assignPool', serviceType: serviceType,
      'session', 'Assign', success: (response) ->
        console.log 'API POST Success:', response
        AppDispatcher.trigger  'session:Assign:success', response
        Queue.socket.updateSessions() if Queue.socket

  refresh: (target) ->
    Utils.mkApiGetter '/session/' + target, 'session', 'Session'

  refreshMessages: (target) ->
    Utils.mkApiGetter '/session/' + target, 'session', 'Session' # DEBUG

  getByServiceType: ->
    Utils.mkApiGetter '/sessions/assigned', 'serviceTypes', 'ServiceTypes'

module.exports = SessionActions