AppDispatcher = require '../dispatcher/AppDispatcher'
Utils = require '../util/actionsUtils'
Backbone = require 'exoskeleton'
PageActions = require './PageActions'

SessionActions =

  create: (service) ->
    Backbone.ajax
      url: window.apiServer + '/session/create'
      contentType: "application/json; charset=utf-8"
      type: 'POST'
      dataType: 'jsonp'
      data: JSON.stringify service: service
      success: (result) ->
        PageActions.navigate '/session/' + result.session.id
      error: (xhr, status) ->
        # TODO
        # Si en el proceso de pago el medico deja de estar disponible,
        # aqui es donde hay que redireccionar a programar la session
        console.error 'Can\t create session', status, xhr

  book: (service, startDate) ->
    Backbone.ajax
      url: window.apiServer + '/session/book'
      contentType: "application/json; charset=utf-8"
      type: 'POST'
      dataType: 'jsonp'
      data: JSON.stringify service: service, startDate: startDate
      success: (result) ->
        PageActions.navigate '/session/' + result.session.id
      error: (xhr, status) ->
        console.error 'Can\t create session', status, xhr

  assign: (serviceType) ->
    Utils.mkApiPoster '/session/assignPool', serviceType: serviceType,
      'session:', 'Assign'

  refresh: (target) ->
    Utils.mkApiGetter '/session/' + target, 'session:', 'Session'

  refreshMessages: (target) ->
    Utils.mkApiGetter '/session/' + target, 'session:', 'Session' # DEBUG

  getByServiceType: ->
    Utils.mkApiGetter '/sessions/assigned', 'serviceTypes:', 'ServiceTypes'

module.exports = SessionActions